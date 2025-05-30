part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<flutter_chat_core.Message> messages;

  ChatLoaded({required this.messages});
}

final class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}

final class ChatMessageSending extends ChatState {
  final List<types.Message> messages;

  ChatMessageSending({required this.messages});
}

final class ChatMessageSent extends ChatState {
  final List<types.Message> messages;

  ChatMessageSent({required this.messages});
}

final class ChatCanceling extends ChatState {}
final class ChatCanceled extends ChatState {}

final class ChatCancelError extends ChatState {
  final String message;

  ChatCancelError({required this.message});
}

class EarlierMessagesLoading extends ChatState {
  final List<types.TextMessage> messages;
  EarlierMessagesLoading({required this.messages});
}

class EarlierMessagesLoaded extends ChatState {
  final List<types.TextMessage> messages;
  final bool hasMore; // indicate if there are more messages to load
  EarlierMessagesLoaded({required this.messages, required this.hasMore});
}