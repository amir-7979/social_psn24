part of 'cropper_bloc.dart';

@immutable
abstract class CropperEvent {}

class PhotoUploadEvent extends CropperEvent {
  final XFile file;

  PhotoUploadEvent(this.file);
}