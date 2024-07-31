part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {

}

class FetchProfile extends ProfileEvent {
  int? id;
  FetchProfile({this.id});
}

class FetchProfileForEditScreen extends ProfileEvent {
  int? id;
  FetchProfileForEditScreen({this.id});
}


class EditProfile extends ProfileEvent {
  final String? name;
  final String? family;
  final String? username;
  final String? photoUrl;
  final String? biography;
  final String? experience;


  EditProfile({
    this.name,
    this.family,
    this.username,
    this.photoUrl,
    this.biography,
    this.experience,

  });
}

class NavigateToEditProfile extends ProfileEvent {}

class NavigateToInitialScreen extends ProfileEvent {}

class DeletePost extends ProfileEvent {
  final String postId;

  DeletePost(this.postId);
}

class ChangeStatusEvent extends ProfileEvent {
  final bool status;

  ChangeStatusEvent(this.status);
}

class ToggleNotificationEvent extends ProfileEvent {
  final int id;
  ToggleNotificationEvent(this.id);
}

