import 'package:social_psn/repos/models/thumbnail.dart';

class NotificationDataDetails {
  final String? postId;
  final List<Thumbnail>? thumbnails;
  final String? commentId;
  final String? userPhoto;
  final String? commentMessage;
  final String? commentCreatedAt;
  final String? replayToCommentId;
  final int? commentUserGlobalId;
  final String? callbackUrl;

  NotificationDataDetails({
    this.postId,
    this.thumbnails,
    this.commentId,
    this.userPhoto,
    this.commentMessage,
    this.commentCreatedAt,
    this.replayToCommentId,
    this.commentUserGlobalId,
    this.callbackUrl,
  });

  factory NotificationDataDetails.fromJson(Map<String, dynamic> json) {
    if(json['thumbnail'] != null )print(json['thumbnails']);
    return NotificationDataDetails(
      postId: json['post_id'],
      thumbnails: (json['thumbnail'] as List<dynamic>?)
          ?.map((e) => Thumbnail.fromJson(e as Map<String, dynamic>))
          .toList(),
      commentId: json['comment_id'],
      userPhoto: json['user_photo'],
      commentMessage: json['comment_message'],
      commentCreatedAt: json['comment_created_at'],
      replayToCommentId: json['replayToComment_id'],
      commentUserGlobalId: json['comment_user_global_id'],
      callbackUrl: json['callback_url'],
    );
  }
}