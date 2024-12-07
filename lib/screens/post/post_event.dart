part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class AddToInterestEvent extends PostEvent {
  final String itemId;

  AddToInterestEvent(this.itemId);
}

class EnableNotificationEvent extends PostEvent {
  final String postId;

  EnableNotificationEvent(this.postId);
}


class UserVoteUpEvent extends PostEvent {
  final String postId;
  final String voteType; // true or false

  UserVoteUpEvent(this.postId, this.voteType);
}

class UserVoteDownEvent extends PostEvent {
  final String postId;
  final String voteType; // true or false

  UserVoteDownEvent(this.postId, this.voteType);
}

class UpdatePostEvent extends PostEvent {
  final String postId;
  final String title;
  final String description;

  UpdatePostEvent(this.postId, this.title, this.description);
}
