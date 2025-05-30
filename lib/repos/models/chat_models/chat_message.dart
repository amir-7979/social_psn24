import 'package:flutter_chat_core/flutter_chat_core.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class NewChatMessage {
  final int? id;
  final int? conversationId;
  final int? receiverId;
  final int? senderId;
  final String? text;
  final String? createdAt;
  final String? updatedAt;
  final String? uuid;
  final String? deletedAt;
  final int? replyToId;
  final int? hasFile;
  final String? fileType;
  final String? status;
  final String? deliveredAt;
  final String? seenAt;
  final String? formattedCreatedAt;
  final dynamic file;

  NewChatMessage({
    this.id,
    this.conversationId,
    this.receiverId,
    this.senderId,
    this.text,
    this.createdAt,
    this.updatedAt,
    this.uuid,
    this.deletedAt,
    this.replyToId,
    this.hasFile,
    this.fileType,
    this.status,
    this.deliveredAt,
    this.seenAt,
    this.formattedCreatedAt,
    this.file,
  });

  factory NewChatMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NewChatMessage();
    //print sender and recirver id
    print('NewChatMessage.fromJson: senderId=${json['sender_id']}, receiverId=${json['receiver_id']}');
    return NewChatMessage(
      id: json['id'] as int?,
      conversationId: json['conversation_id'] as int?,
      receiverId: json['receiver_id'] as int?,
      senderId: json['sender_id'] as int?,
      text: json['text'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      uuid: json['uuid'] as String?,
      deletedAt: json['deleted_at'] as String?,
      replyToId: json['reply_to_id'] as int?,
      hasFile: json['has_file'] as int?,
      fileType: json['file_type'] as String?,
      status: json['status'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      seenAt: json['seen_at'] as String?,
      formattedCreatedAt: json['formatted_created_at'] as String?,
      file: json['file'],
    );
  }


  types.TextMessage toTypesMessage() {
    return types.TextMessage(
      id: uuid!,
      authorId: senderId.toString(),
      text: text ?? '',
      createdAt: DateTime.parse(createdAt!)
    );
  }
}
