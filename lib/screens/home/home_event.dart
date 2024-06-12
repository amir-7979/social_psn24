part of 'home_bloc.dart';

abstract class HomeEvent {}

class LoadPostsEvent extends HomeEvent {}

class RefreshPostsEvent extends HomeEvent {}

class AddToInterestEvent extends HomeEvent {
  final String itemId;

  AddToInterestEvent(this.itemId);
}

class EnableNotificationEvent extends HomeEvent {
  final String postId;

  EnableNotificationEvent(this.postId);
}