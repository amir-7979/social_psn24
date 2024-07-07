part of 'post_detailed_bloc.dart';

@immutable
sealed class PostDetailedState {}

final class PostDetailedInitial extends PostDetailedState {}

class CommentCountUpdated extends PostDetailedState {
  final int updatedCount;

  CommentCountUpdated(this.updatedCount);
}

class PostRefreshSuccess extends PostDetailedState {}

class InterestSuccessState extends PostDetailedState {}

class InterestFailureState extends PostDetailedState {}

class NotificationSuccessState extends PostDetailedState {}

class NotificationFailureState extends PostDetailedState {}

class UserVoteUpSuccessState extends PostDetailedState {}

class UserVoteUpFailureState extends PostDetailedState {}

class UserVoteDownSuccessState extends PostDetailedState {}

class UserVoteDownFailureState extends PostDetailedState {}

class CreatingComment extends PostDetailedState {}

class CommentCreated extends PostDetailedState {
  final String message;
  CommentCreated({required this.message});
}

class CommentFailure extends PostDetailedState {
  final String error;

  CommentFailure({required this.error});
}

class CommentCountRefresh extends PostDetailedState {}

class CommentListRefresh extends PostDetailedState {}

class IncreasePostViewSuccess extends PostDetailedState {}
