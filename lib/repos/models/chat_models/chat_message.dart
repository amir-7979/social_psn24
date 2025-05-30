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
      createdAt: DateTime.parse(createdAt!),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      deliveredAt: deliveredAt != null ? DateTime.parse(deliveredAt!) : null,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
      seenAt: seenAt != null ? DateTime.parse(seenAt!) : null,
      replyToMessageId: replyToId != null ? replyToId.toString() : null,
      sentAt: DateTime.parse(createdAt!),

      metadata: {
        'fileType': fileType,
        'hasFile': hasFile,
        'formattedCreatedAt': formattedCreatedAt,
        'file': file,
      },
    );
  }

  types.Message toTypesMessageWithFile() {
    return types.FileMessage(
      id: uuid!,
      authorId: senderId.toString(),
      createdAt: DateTime.parse(createdAt!),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      deliveredAt: deliveredAt != null ? DateTime.parse(deliveredAt!) : null,
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
      seenAt: seenAt != null ? DateTime.parse(seenAt!) : null,
      replyToMessageId: replyToId != null ? replyToId.toString() : null,
      sentAt: DateTime.parse(createdAt!),
      source: file['uri'] ?? '',
      name: file['name'] ?? '',
      metadata: {
        'fileType': fileType,
        'hasFile': hasFile,
        'formattedCreatedAt': formattedCreatedAt,
      },
      size: file['size'] ?? 0,
      mimeType: fileType ?? 'application/octet-stream',

    );
  }

}
