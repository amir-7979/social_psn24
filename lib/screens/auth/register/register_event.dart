part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class EditUserEvent extends RegisterEvent {
  final String name;
  final String family;
  final String username;
  final String? photoUrl;
  EditUserEvent({required this.name, required this.family, required this.username, this.photoUrl});
}

class PhotoUploadEvent extends RegisterEvent {
  final String? file;
  PhotoUploadEvent(this.file);
}
