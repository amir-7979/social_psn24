class NotificationSender {
  final int? id;
  final String? fullName;
  final String? username;
  final String? photo;

  NotificationSender({
    this.id,
    this.fullName,
    this.username,
    this.photo,
  });

  factory NotificationSender.fromJson(Map<String, dynamic> json) {
    return NotificationSender(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      photo: json['photo'],
    );
  }
}
