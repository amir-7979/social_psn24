part of 'profile_picture_bloc.dart';

@immutable
abstract class ProfilePictureState {}

class ProfilePictureInitial extends ProfilePictureState {}

class ProfilePictureLoading extends ProfilePictureState {}

class ProfilePictureSuccess extends ProfilePictureState {
  final String imageUrl;

  ProfilePictureSuccess(this.imageUrl);
}
class ProfilePictureRemove extends ProfilePictureState {}
class ProfilePictureFailure extends ProfilePictureState {
  final String? error;

  ProfilePictureFailure(this.error);
}