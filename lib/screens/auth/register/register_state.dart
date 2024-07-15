part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterFinished extends RegisterState {
  final String token;

  RegisterFinished(this.token);
}

final class RegisterFailure extends RegisterState {
  final String error;
  final String? widget;

  RegisterFailure(this.error, {this.widget});
}

class PhotoUploadInitial extends RegisterState {}

class PhotoUploading extends RegisterState {}

class PhotoUploadCompleted extends RegisterState {
  final String photoUrl;

  PhotoUploadCompleted(this.photoUrl);
}

class PhotoUploadFailed extends RegisterState {
  final String error;

  PhotoUploadFailed(this.error);
}
