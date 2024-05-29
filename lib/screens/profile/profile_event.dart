part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {

}

class FetchProfile extends ProfileEvent {
  int? id;
  FetchProfile({this.id});
}


class EditProfile extends ProfileEvent {
  final String? name;
  final String? family;
  final String? id;
  final String? biography;
  final String? field;
  final String? experience;
  final String? address;
  final List<String>? office;
  final int? showActivity;
  final String? username;

  EditProfile({
    this.name,
    this.family,
    this.id,
    this.biography,
    this.field,
    this.experience,
    this.address,
    this.office,
    this.showActivity,
    this.username,
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

class PhotoUploadEvent extends ProfileEvent {
  final String? file;

  PhotoUploadEvent(this.file);
}