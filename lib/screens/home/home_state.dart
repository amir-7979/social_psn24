part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class PostRefreshSuccess extends HomeState {}

class CommentRefreshSuccess extends HomeState {}

class goToDetailedPostState extends HomeState {
  final Post post;

  goToDetailedPostState(this.post);
}


class CreatingComment extends HomeState {}

class CommentCreated extends HomeState {
  final String message;

  CommentCreated({required this.message});
}

class CommentFailure extends HomeState {
  final String error;

  CommentFailure({required this.error});
}