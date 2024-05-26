part of 'auth_bloc.dart';

abstract class AuthState {}

class InitState extends AuthState {}

class AuthLoginState extends AuthState {}

class AuthVerifyState extends AuthState {
  String phoneNumber;
  String? lastCode;
  AuthVerifyState(this.phoneNumber, {this.lastCode});
}

class AuthResetPin extends AuthState {
  AuthResetPin();
}

class AuthResetPinNotif extends AuthState {
  final String error;

  AuthResetPinNotif(this.error);
}
class AuthRegisterState extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFinished extends AuthState {
  final String token;

  AuthFinished(this.token);

}

class AuthFailure extends AuthState {
  final String error;
  final String? widget;

  AuthFailure(this.error, {this.widget});
}

class PhotoUploadInitial extends AuthState {}

class PhotoUploading extends AuthState {}

class PhotoUploadCompleted extends AuthState {
  final String photoUrl;

  PhotoUploadCompleted(this.photoUrl);
}

class PhotoUploadFailed extends AuthState {
  final String error;

  PhotoUploadFailed(this.error);
}