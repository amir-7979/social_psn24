import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart' as flutter_chat_core;
import 'package:flutter_chat_core/src/chat_controller/in_memory_chat_controller.dart';
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
  InMemoryChatController chatController;
  int _currentPage = 1;

  WebSocketChannel? wsChannel;
  StreamSubscription? _wsSubscription;
  List<NewChatMessage> _messages = [];

  ChatBloc({
    required this.currentUser,
    required this.wsDomain,
    required this.chatController,
    required chatUuid,
  }) : super(ChatInitial()) {
    on<ChatInitEvent>(_onChatInit);
    on<SendChatMessageEvent>(_onSendChatMessage);
    on<NewChatMessageReceivedEvent>(_onNewChatMessageReceived);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<FinishChatEvent>(_onFinishChat);
    on<LoadEarlierMessagesEvent>((event, emit) async {
      await _onLoadEarlierMessages(event, emit);
    });
  }
  Future<void> _onChatInit(ChatInitEvent event, Emitter<ChatState> emit) async {
    _currentPage = 1;
    emit(ChatLoading());
    try {
      await _fetchAndEmitMessages(event, emit);

      bool isCanceled = await _checkAndEmitStatus(event, emit);
      if (isCanceled) return;

      await _connectAndListenWebSocket(event, emit);

    } on FormatException catch (e) {
      print('[ChatBloc] JSON Format Error: $e');
      emit(ChatError("خطا در پردازش داده: ${e.toString()}"));
    } on WebSocketChannelException catch (e) {
      print('[ChatBloc] WebSocket CONNECT ERROR: $e');
      emit(ChatError('خطا در اتصال سوکت: $e'));
    } catch (e) {
      print('[ChatBloc] General Error: $e');
      emit(ChatError("خطا در بارگذاری پیام‌ها: ${e.toString()}"));
    }
  }

  Future<void> _fetchAndEmitMessages(ChatInitEvent event, Emitter<ChatState> emit) async {
    final response = await chatRepository.fetchMessages(event.chatUuid);
    print("[ChatBloc] Fetch messages response: ${response.data.toString()}");
    final parsed = FetchMessagesResponse.fromJson(response.data);

    final List<NewChatMessage> chatMessages = parsed.messages?.data ?? [];
    List<flutter_chat_core.Message> messages = chatMessages
        .map((msg) => msg.toTypesMessage())
        .toList();
    messages = messages.reversed.toList();
    emit(ChatLoaded(messages: messages));
  }

  Future<bool> _checkAndEmitStatus(ChatInitEvent event, Emitter<ChatState> emit) async {
    final response2 = await chatRepository.getConversationStatus(event.chatUuid);
    FetchMessagesResponse fetchMessagesResponse = FetchMessagesResponse.fromJson(response2.data['data']);
    if (fetchMessagesResponse.status == 'finished') {
      print("cancellllll ${response2.data}");
      emit(ChatCanceled());
      return true; // Signal that chat is canceled
    }
    return false;
  }

  Future<void> _connectAndListenWebSocket(ChatInitEvent event, Emitter<ChatState> emit) async {
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
        } catch (err) {
          print('[ChatBloc] WebSocket JSON parse error: $err');
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
  }


  Future<void> _onSendChatMessage(SendChatMessageEvent event, Emitter<ChatState> emit) async {
    emit(ChatMessageSending(messages: _messages.map(_toTypesMessage).toList()));
    try {
      final response = await chatRepository.sendMessage(event.chatUuid, event.text);

      if (response.data == null || response.data['data'] == null) {
        emit(ChatError("خطا در ارسال پیام: دریافت داده نامعتبر"));
        return;
      }

      final sentMsg = NewChatMessage.fromJson(response.data['data']);
      _messages.add(sentMsg);

      emit(ChatMessageSent(messages: List.from(_messages.map(_toTypesMessage))));
    } catch (e) {
      emit(ChatError("خطا در ارسال پیام: ${e.toString()}"));
    }
  }

  void _onNewChatMessageReceived(NewChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    final newMsg = NewChatMessage.fromJson(event.messageJson);
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
  types.TextMessage _toTypesMessage(NewChatMessage msg) {
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




  _onLoadEarlierMessages(event, emit) async {
    emit(EarlierMessagesLoading(messages: _messages.map(_toTypesMessage).toList()));
    try {
      final response = await chatRepository.getMessagesListPagination(event.chatUuid, event.page);
      final parsed = FetchMessagesResponse.fromJson(response.data);

      final List<NewChatMessage> newMessages = parsed.messages?.data ?? [];
      if (newMessages.isEmpty) {
        emit(EarlierMessagesLoaded(
          messages: _messages.map(_toTypesMessage).toList(),
          hasMore: false,
        ));
        return;
      }
      // Prepend new messages (since they're older)
      _messages = [...newMessages.reversed, ..._messages];
      emit(EarlierMessagesLoaded(
        messages: _messages.map(_toTypesMessage).toList(),
        hasMore: true, // You can check if newMessages.length < pageSize to set this
      ));
      _currentPage = event.page;
    } catch (e) {
      emit(ChatError("خطا در بارگذاری پیام‌های قبلی: ${e.toString()}"));
    }
  }


}
