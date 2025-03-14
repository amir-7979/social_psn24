import 'package:shamsi_date/shamsi_date.dart';

import 'post_details.dart';
import 'reply.dart';
import 'sender.dart';

class Comment {
  final String? id;
  final String? message;
  final String? createdAt;
  final String? persianDate;
  final String? replyTo;
  final List<Reply>? replies;
  final PostDetails? post;
  final Sender? sender;

  Comment({
    this.id,
    this.message,
    this.createdAt,
    this.persianDate,
    this.replyTo,
    this.replies,
    this.post,
    this.sender,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    String? createdAt = json['created_at'];
    Jalali? jalaliDate = createdAt != null ? Jalali.fromDateTime(DateTime.parse(createdAt)) : null;
    String? formattedPersianDate = jalaliDate != null ? '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}' : null;
    return Comment(
      id: json['id'],
      message: json['message'],
      createdAt: createdAt,
      persianDate: formattedPersianDate,
      replyTo: json['reply_to'],
      replies: json['replies'] != null
          ? (json['replies'] as List<dynamic>)
          .map((item) => Reply.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
      post: json['post_id'] != null ? PostDetails.fromJson(json['post_id']) : null,
      sender: json['sender_id'] != null ? Sender.fromJson(json['sender_id']) : null,
    );
  }
}