part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadPostsEvent extends HomeEvent {}

class RefreshPostsEvent extends HomeEvent {}

class RefreshIndexEvent extends HomeEvent {
  final Post post;

  RefreshIndexEvent(this.post);
}

