part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadPostsEvent extends HomeEvent {}

class RefreshPostsEvent extends HomeEvent {}

class RefreshIndexEvent extends HomeEvent {
  final Post post;

  RefreshIndexEvent(this.post);
}

class SearchPostsEvent extends HomeEvent {
  final String? query;
  final String? tag;
  final int? type;
  SearchPostsEvent(this.query, this.tag, this.type);
}

