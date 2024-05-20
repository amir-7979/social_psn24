class Reply {
  final String id;
  final String message;

  Reply({required this.id, required this.message});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      message: json['message'],
    );
  }
}
