import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:meta/meta.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../repos/models/chat_models/chat_message.dart';
import '../../repos/models/chat_models/fetch_messages_response.dart';
import '../../repos/repositories/dio/consultation/chat_repository.dart';
import '../../secret.dart';
import '../../services/storage_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository = ChatRepository();
  final types.User currentUser;
  final String wsDomain;
  final StorageService _storageService = StorageService();

  WebSocketChannel? wsChannel;
  StreamSubscription? _wsSubscription;
  List<ChatMessage> _messages = [];

  ChatBloc({
    required this.currentUser,
    required this.wsDomain,
    required chatUuid,
  }) : super(ChatInitial()) {
    on<ChatInitEvent>(_onChatInit);
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<NewChatMessageReceivedEvent>(_onNewChatMessageReceived);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<FinishChatEvent>(_onFinishChat);
  }
  Future<void> _onChatInit(ChatInitEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final response = await chatRepository.fetchMessages(event.chatUuid);
      if (response.data == null) {
        print("[ChatBloc] Invalid response data: ${response.data}");
        emit(ChatError("خطا در بارگذاری پیام‌ها: دریافت داده نامعتبر"));
        return;
      }

      final parsed = FetchMessagesResponse.fromJson(response.data);
      final List<ChatMessage> chatMessages = parsed.messages?.data ?? [];
      _messages = chatMessages.reversed.toList();
      print("[ChatBloc] Loaded messages: ${_messages.length}");
      emit(ChatLoaded(messages: _messages.map(_toTypesMessage).toList()));
      print('[ChatBloc] Attempting WebSocket connect to: $wsDomain');
      final token = await _storageService.readData('token');
      final wsDomainWithParams = '$wsDomain?token=$token&service-token=$Secret2';

      wsChannel = WebSocketChannel.connect(Uri.parse(wsDomainWithParams));

      _wsSubscription = wsChannel!.stream.listen(
            (data) {
          print('[ChatBloc] WebSocket DATA: $data');
          try {
            final decoded = data is String ? data : data.toString();
            final eventData = jsonDecode(decoded);
            if (eventData != null && eventData['event'] == 'message.new') {
              add(NewChatMessageReceivedEvent(messageJson: eventData['data']));
            }
          } catch (err, stack) {
            print('[ChatBloc] WebSocket JSON parse error: $err');
            // Optionally: add(ChatSocketErrorEvent(err.toString()));
          }
        },
        onError: (error, [stackTrace]) {
          print('[ChatBloc] WebSocket STREAM ERROR: $error');
          emit(ChatError('خطا در سوکت: $error'));
        },
        onDone: () {
          print('[ChatBloc] WebSocket connection closed');
        },
        cancelOnError: true,
      );

    } on FormatException catch (e, stack) {
      print('[ChatBloc] JSON Format Error: $e');
      emit(ChatError("خطا در پردازش داده: ${e.toString()}"));
    } on WebSocketChannelException catch (e, stack) {
      print('[ChatBloc] WebSocket CONNECT ERROR: $e');
      emit(ChatError('خطا در اتصال سوکت: $e'));
    } catch (e, stack) {
      print('[ChatBloc] General Error: $e');
      emit(ChatError("خطا در بارگذاری پیام‌ها: ${e.toString()}"));
    }
  }

  Future<void> _onSendChatMessage(SendChatMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessageSending(messages: _messages.map(_toTypesMessage).toList()));
    try {
      final response = await chatRepository.sendMessage(event.chatUuid, event.text);

      if (response.data == null || response.data['data'] == null) {
        emit(ChatError("خطا در ارسال پیام: دریافت داده نامعتبر"));
        return;
      }

      final sentMsg = ChatMessage.fromJson(response.data['data']);
      _messages.add(sentMsg);

      emit(ChatMessageSent(messages: List.from(_messages.map(_toTypesMessage))));
    } catch (e) {
      emit(ChatError("خطا در ارسال پیام: ${e.toString()}"));
    }
  }

  void _onNewChatMessageReceived(NewChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    final newMsg = ChatMessage.fromJson(event.messageJson);
    _messages.add(newMsg);
    emit(ChatLoaded(messages: List.from(_messages.map(_toTypesMessage))));
  }

  void _onDisconnectWebSocket(DisconnectWebSocketEvent event, Emitter<ChatState> emit) {
    print('[ChatBloc] WebSocket disconnecting...');
    _wsSubscription?.cancel();
    wsChannel?.sink.close();
    print('[ChatBloc] WebSocket disconnected.');
  }

  // Helper: Convert ChatMessage to flutter_chat_types TextMessage
  types.TextMessage _toTypesMessage(ChatMessage msg) {
    return types.TextMessage(
      author: types.User(id: msg.senderId?.toString() ?? ''),
      id: msg.uuid ?? msg.id?.toString() ?? '',
      text: msg.text ?? '',
      createdAt: msg.createdAt != null
          ? DateTime.parse(msg.createdAt!).millisecondsSinceEpoch
          : DateTime.now().millisecondsSinceEpoch,
    );
  }


  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    wsChannel?.sink.close();
    return super.close();
  }

  Future<void> _onFinishChat(FinishChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatCanceling());
    try {
      var response = await chatRepository.cancelConversation(event.chatUuid);
      print("[ChatBloc] Cancel conversation response: ${response.data.toString()}");
     emit(ChatCanceled());
    } catch (e) {
      print("[ChatBloc] Error canceling conversation: $e");
      emit(ChatCancelError(message: e.toString()));
    }
  }
}
