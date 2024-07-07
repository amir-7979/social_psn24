part of 'post_detailed_bloc.dart';

@immutable
sealed class PostDetailedEvent {}

class AddToInterestEvent extends PostDetailedEvent {
  final String itemId;

  AddToInterestEvent(this.itemId);
}

class EnableNotificationEvent extends PostDetailedEvent {
  final String postId;

  EnableNotificationEvent(this.postId);
}

class UserVoteUpEvent extends PostDetailedEvent {
  final String postId;
  final String voteType; // true or false

  UserVoteUpEvent(this.postId, this.voteType);
}

class UserVoteDownEvent extends PostDetailedEvent {
  final String postId;
  final String voteType; // true or false

  UserVoteDownEvent(this.postId, this.voteType);
}


class CreateCommentEvent extends PostDetailedEvent {
  final String postId;
  final String? replyId;
  final String message;

  CreateCommentEvent({required this.postId, this.replyId, required this.message});
}

class IncreasePostViewEvent extends PostDetailedEvent {
  final String postId;
  final int? viewCount;
  final int? status;

  IncreasePostViewEvent({required this.postId, this.viewCount = 1, this.status = 0});
}