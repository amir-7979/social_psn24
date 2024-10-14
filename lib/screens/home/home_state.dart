part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class PostRefreshSuccess extends HomeState {}

class goToDetailedPostState extends HomeState {
  final Post post;

  goToDetailedPostState(this.post);
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

