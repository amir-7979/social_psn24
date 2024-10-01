part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}


//profile loading section

class ProfileInitial extends ProfileState {}

class ProfileInfoLoading extends ProfileState {}

class ProfileInfoLoaded extends ProfileState {
  final Profile profile;

  ProfileInfoLoaded({required this.profile});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}


//post deleting section

class PostDeleting extends ProfileState {
  final String id;

  PostDeleting(this.id);
}

class PostDeleteSuccess extends ProfileState {}

class PostDeleteFailure extends ProfileState {
  final String error;

  PostDeleteFailure(this.error);
}


//change status section

class ChangeOnlineStatusFailed extends ProfileState {}

class ChangeOnlineStatusSucceed extends ProfileState {
  final bool status;

  ChangeOnlineStatusSucceed(this.status);
}


//toggle notification section

class TogglingNotificationState extends ProfileState {}

class ToggleNotificationFailure extends ProfileState {
  final String message;

  ToggleNotificationFailure(this.message);
}

class ToggleNotificationSuccess extends ProfileState {}


//activity section

class ActivityLoadingState extends ProfileState {}

class activityFailureState extends ProfileState {
  final String message;

  activityFailureState(this.message);
}

class activitySuccessState extends ProfileState {
  final Map<String, dynamic> activity;

  activitySuccessState(this.activity);
}

// change content section
class ChangeToPostState extends ProfileState {}

class ChangeToCommentState extends ProfileState {}



