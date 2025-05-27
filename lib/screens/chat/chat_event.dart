part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class ChatInitEvent extends ChatEvent {
  final String chatUuid;
  ChatInitEvent({required this.chatUuid});
}

class FetchChatHistoryEvent extends ChatEvent {
  final String chatUuid;

  FetchChatHistoryEvent({required this.chatUuid});
}

class SendChatMessageEvent extends ChatEvent {
  final String chatUuid;
  final String text;

  SendChatMessageEvent({
    required this.chatUuid,
    required this.text,
  });
}

class NewChatMessageReceivedEvent extends ChatEvent {
  final Map<String, dynamic> messageJson;

  NewChatMessageReceivedEvent({required this.messageJson});
}

class ConnectWebSocketEvent extends ChatEvent {}

class DisconnectWebSocketEvent extends ChatEvent {}

class FinishChatEvent extends ChatEvent {
  final String chatUuid;

  FinishChatEvent({required this.chatUuid});
}
