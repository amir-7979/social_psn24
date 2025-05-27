class ChatMessage {
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

  ChatMessage({
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

  factory ChatMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ChatMessage();
    return ChatMessage(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'text': text,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'uuid': uuid,
      'deleted_at': deletedAt,
      'reply_to_id': replyToId,
      'has_file': hasFile,
      'file_type': fileType,
      'status': status,
      'delivered_at': deliveredAt,
      'seen_at': seenAt,
      'formatted_created_at': formattedCreatedAt,
      'file': file,
    };
  }
}