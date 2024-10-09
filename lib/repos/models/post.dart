import 'package:shamsi_date/shamsi_date.dart';

import 'creator.dart';
import 'media.dart';

class Post {
  final String id;
  final String? tagId;
  final String? name;
  final String? description;
  final String? createdAt;
  final String? persianDate;
  bool currentUserLiked;
  bool currentUserUpVotes;
  bool currentUserDownVotes;
  bool currentUserNotificationEnabled;
  final int? postType;
  final bool? isPublish;
  int? commentsCount = 0;
  int? downVotes;
  int? upVotes;
  int? viewCount;
  final Creator? creator;
  List<Media>? medias;
  bool voteUp = false;
  bool voteDown = false;
  bool isLiked = false;
  bool isNotificationEnabled = false;

  Post({
    required this.id,
    this.tagId,
    this.name,
    this.description,
    this.createdAt,
    this.persianDate,
    required this.currentUserLiked,
    required this.currentUserUpVotes,
    required this.currentUserDownVotes,
    required this.currentUserNotificationEnabled,
    this.postType,
    this.isPublish,
    this.commentsCount,
    this.downVotes,
    this.upVotes,
    this.viewCount,
    this.creator,
    this.medias,
    this.voteUp = false,
    this.voteDown = false,
    this.isLiked = false,
    this.isNotificationEnabled = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String createdAt = json['created_at'];
    Jalali jalaliDate = Jalali.fromDateTime(DateTime.parse(createdAt));
    String formattedPersianDate =
        '${jalaliDate.day} ${jalaliDate.formatter.mN} ${jalaliDate.year}';
    return Post(
      id: json['id'],
      tagId: json['tag_id'],
      name: json['name'],
      description: json['description'],
      createdAt: createdAt,
      persianDate: formattedPersianDate,
      currentUserLiked: json['current_user_liked'] ?? false,
      currentUserUpVotes: json['current_user_up_votes'] ?? false,
      currentUserDownVotes: json['current_user_down_votes'] ?? false,
      currentUserNotificationEnabled:
          json['current_user_notification_enabled'] ?? false,
      postType: json['post_type'],
      isPublish: json['is_publish'],
      commentsCount: json['comments_count'] ?? 0,
      downVotes: json['down_votes'],
      upVotes: json['up_votes'],
      viewCount: json['view_count'],
      creator:
          json['creator'] != null ? Creator.fromJson(json['creator']) : null,
      medias: json['medias'] != null
          ? (json['medias'] as List).map((i) => Media.fromJson(i)).toList()
          : null,
      voteUp: json['current_user_up_votes'] ?? false,
      voteDown: json['current_user_down_votes'] ?? false,
      isLiked: json['current_user_liked'] ?? false,
      isNotificationEnabled: json['current_user_notification_enabled'] ?? false,
    );
  }

  String _formatCount(int? count) {
    if (count == null || count == 0) {
      return '0';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(0)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    } else {
      return count.toString();
    }
  }

  String get viewCountString => _formatCount(viewCount);

  /// Formatted string for comments count.
  String get commentsCountString => _formatCount(commentsCount);

  /// Formatted string for down votes.
  String get downVotesString => _formatCount(downVotes);

  /// Formatted string for up votes.
  String get upVotesString => _formatCount(upVotes);
}
