part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GotoLoginEvent extends AuthEvent {}


class LogInEvent extends AuthEvent {
  final String phoneNumber;
  LogInEvent(this.phoneNumber);
}

class VerifyTokenEvent extends AuthEvent {
  String code;

  VerifyTokenEvent(this.code);
}

class EditUserEvent extends AuthEvent {
  final String name;
  final String family;
  final String username;
  final int showActivity;

  EditUserEvent(this.name, this.family, this.username, this.showActivity);
}

class PhotoUploadEvent extends AuthEvent {
  final String? file;

  PhotoUploadEvent(this.file);
}