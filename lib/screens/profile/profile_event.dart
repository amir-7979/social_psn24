part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class FetchProfileEvent extends ProfileEvent {
  final int? id;
  FetchProfileEvent({this.id});
}

class FetchMyProfileEvent extends ProfileEvent {

  FetchMyProfileEvent();
}

class FetchMyActivityEvent extends ProfileEvent {
  final int? id;
  FetchMyActivityEvent({this.id});
}

class DeletePostEvent extends ProfileEvent {
  final String postId;

  DeletePostEvent(this.postId);
}

class EditPostEvent extends ProfileEvent {
  final String postId;

  EditPostEvent(this.postId);
}

class ChangeStatusEvent extends ProfileEvent {
  final bool status;
  final String name, family;

  ChangeStatusEvent({required this.status, required this.name, required this.family});
}

class ToggleNotificationEvent extends ProfileEvent {
  final int id;
  ToggleNotificationEvent(this.id);
}

class ChangeToPostEvent extends ProfileEvent {}

class ChangeToCommentEvent extends ProfileEvent {}


