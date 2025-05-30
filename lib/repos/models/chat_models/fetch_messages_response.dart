import 'messages_list_pagination.dart';
import 'chat_participants.dart';

class FetchMessagesResponse {
  final String? status;
  final MessagesListPagination? messages;
  final ChatParticipants? participants;

  FetchMessagesResponse({
    this.status,
    this.messages,
    this.participants,
  });

  factory FetchMessagesResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FetchMessagesResponse();
    return FetchMessagesResponse(
      status: json['status'] as String?,
      messages: MessagesListPagination.fromJson(json['messages']),
      participants: ChatParticipants.fromJson(json['participants']),
    );
  }

}