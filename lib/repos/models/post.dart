import 'package:shamsi_date/shamsi_date.dart';

import 'creator.dart';
import 'media.dart';

class Post {
  final String id;
  final int? tagId;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? persianDate;
   bool? currentUserLiked;
   bool? currentUserUpVotes;
   bool? currentUserDownVotes;
   bool? currentUserNotificationEnabled;
  final int? postType;
  final bool? isPublish;
  final int? commentsCount;
  final int? downVotes;
  final int? upVotes;
  final int? viewCount;
  final Creator? creator;
  final List<Media>? medias;


  Post({
    required this.id,
    this.tagId,
    this.name,
    this.description,
    this.createdAt,
    this.persianDate,
    this.currentUserLiked,
    this.currentUserUpVotes,
    this.currentUserDownVotes,
    this.currentUserNotificationEnabled,
    this.postType,
    this.isPublish,
    this.commentsCount,
    this.downVotes,
    this.upVotes,
    this.viewCount,
    this.creator,
    this.medias,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String createdAt = json['created_at'];
    Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
    String formattedPersianDate = '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}';

    return Post(
      id: json['id'],
      tagId: json['tag_id'],
      name: json['name'],
      description: json['description'],
      createdAt: createdAt,
      persianDate: formattedPersianDate,
      currentUserLiked: json['current_user_liked'],
      currentUserUpVotes: json['current_user_up_votes'],
      currentUserDownVotes: json['current_user_down_votes'],
      currentUserNotificationEnabled: json['current_user_notification_enabled'],
      postType: json['post_type'],
      isPublish: json['is_publish'],
      commentsCount: json['comments_count'],
      downVotes: json['down_votes'],
      upVotes: json['up_votes'],
      viewCount: json['view_count'],
      creator: json['creator'] != null ? Creator.fromJson(json['creator']) : null,
      medias: json['medias'] != null ? (json['medias'] as List).map((i) => Media.fromJson(i)).toList() : null,
    );
  }
}