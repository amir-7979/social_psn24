class ChatParticipants {
  final int? userOneId;
  final int? userTwoId;

  ChatParticipants({
    this.userOneId,
    this.userTwoId,
  });

  factory ChatParticipants.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ChatParticipants();
    return ChatParticipants(
      userOneId: json['user_one_id'] as int?,
      userTwoId: json['user_two_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_one_id': userOneId,
      'user_two_id': userTwoId,
    };
  }
}