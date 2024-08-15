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

class SearchParams extends HomeState{
  final String? query;
  final String? tag;
  final int? type;

  SearchParams(this.query, this.tag, this.type);
}
class SearchLoadingState extends HomeState {
  final String? query;
  SearchLoadingState(this.query);

}

