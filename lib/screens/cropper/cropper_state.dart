part of 'cropper_bloc.dart';

@immutable
abstract class CropperState {}

class CropperInitial extends CropperState {}

class PhotoUploading extends CropperState {}

class PhotoUploadCompleted extends CropperState {
  final String photoUrl;

  PhotoUploadCompleted(this.photoUrl);
}

class PhotoUploadFailed extends CropperState {
  final String error;

  PhotoUploadFailed(this.error);
}