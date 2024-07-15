part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class EditUserEvent extends RegisterEvent {
  final String name;
  final String family;
  final String username;
  final int showActivity;

  EditUserEvent(this.name, this.family, this.username, this.showActivity);
}

class PhotoUploadEvent extends RegisterEvent {
  final String? file;

  PhotoUploadEvent(this.file);
}
