part of 'profile_picture_bloc.dart';

@immutable
abstract class ProfilePictureEvent {}

class UploadProfilePicture extends ProfilePictureEvent {
  final File? file;

  UploadProfilePicture(this.file);
}