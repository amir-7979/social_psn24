import 'content.dart';
import 'target.dart';

class MyNotification {
  final String? createdAt;
  final int? id;
  final String? message;
  final bool? seen;
  final int? type;
  final Target? target;
  final Content? contentId;

  MyNotification({
    this.createdAt,
    this.id,
    this.message,
    this.seen,
    this.type,
    this.target,
    this.contentId,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      createdAt: json['created_at'],
      id: json['id'],
      message: json['message'],
      seen: json['seen'],
      type: json['type'],
      target: Target.fromJson(json['target_id']),
      contentId: Content.fromJson(json['content_id']),
    );
  }
}