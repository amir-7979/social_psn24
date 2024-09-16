part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
}

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

//---------------------

class NewProfileInfoLoading extends ProfileState {}

class NewProfileInfoLoaded extends ProfileState {
  final Profile profile;

  NewProfileInfoLoaded({required this.profile});
}

class NewProfileError extends ProfileState {
  final String message;

  NewProfileError(this.message);
}

//---------------------

class EditProfileInfoLoading extends ProfileState {}

class EditProfileInfoLoaded extends ProfileState {
  EditProfileInfoLoaded();
}

class EditProfileError extends ProfileState {
  String message;

  EditProfileError(this.message);
}

class EditProfileInfoWithNameLoading extends ProfileState {}

class EditProfileInfoWithNameLoaded extends ProfileState {
  final Profile profile;

  EditProfileInfoWithNameLoaded({required this.profile});
}

class EditProfileInfoWithNameError extends ProfileState {}

class PostDeleting extends ProfileState {
  final String id;

  PostDeleting(this.id);
}

class PostDeleteSuccess extends ProfileState {}

class PostDeleteFailure extends ProfileState {
  final String error;

  PostDeleteFailure(this.error);
}

class ChangeOnlineStatusFailed extends ProfileState {}

class ChangeOnlineStatusSucceed extends ProfileState {
  final bool status;

  ChangeOnlineStatusSucceed(this.status);
}
class NavigationToProfileScreenState extends ProfileState {}

class NavigationToEditScreenState extends ProfileState {}

class TogglingNotificationState extends ProfileState {}

class ToggleNotificationFailure extends ProfileState {
  final String message;

  ToggleNotificationFailure(this.message);
}

class ToggleNotificationSuccess extends ProfileState {}


