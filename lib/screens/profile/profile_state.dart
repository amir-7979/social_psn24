part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileInfoLoading extends ProfileState {}

class ProfileInfoLoaded extends ProfileState {
  final Profile profile;
  final UserPermissions? userPermissions;

  ProfileInfoLoaded({required this.profile, this.userPermissions});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class EditProfileInfoLoading extends ProfileState {}

class EditProfileInfoLoaded extends ProfileState {
  final Profile profile;
  final UserPermissions? userPermissions;

  EditProfileInfoLoaded({required this.profile, this.userPermissions});
}

class EditProfileError extends ProfileState {}

class EditProfileInfoWithNameLoading extends ProfileState {}

class EditProfileInfoWithNameLoaded extends ProfileState {
  final Profile profile;
  final UserPermissions? userPermissions;

  EditProfileInfoWithNameLoaded({required this.profile, this.userPermissions});
}

class EditProfileInfoWithNameError extends ProfileState {}

class ProfilePostsLoading extends ProfileState {}

class ProfileExpertPostsLoading extends ProfileState {}

class NavigationToEditScreenState extends ProfileState {

  NavigationToEditScreenState();
}

class ProfilePostsLoaded extends ProfileState {
  final List<Content> contents;

  ProfilePostsLoaded({required this.contents});
}

class ProfileExpertPostsLoaded extends ProfileState {
  final List<Content> contents;

  ProfileExpertPostsLoaded({required this.contents});
}


class ProfileCommentsLoading extends ProfileState {}

class ProfileExpertCommentsLoading extends ProfileState {}

class ProfileCommentsLoaded extends ProfileState {
  final List<Comment> comments;

  ProfileCommentsLoaded({required this.comments});
}

class ProfileExpertCommentsLoaded extends ProfileState {
  final List<Comment> comments;

  ProfileExpertCommentsLoaded({required this.comments});
}

class PostDeleting extends ProfileState {
  final String id;

  PostDeleting(this.id);
}
class PostDeleteSuccess extends ProfileState {}

class PostDeleteFailure extends ProfileState {
  final String error;

  PostDeleteFailure(this.error);
}

class ChangeOnlineStatus extends ProfileEvent {
  final bool status;

  ChangeOnlineStatus(this.status);
}