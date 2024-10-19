part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String phone, loginId;

  LoginSuccess(this.phone, this.loginId);
}

final class LoginAgain extends LoginState {
  final String phone, message;

  LoginAgain(this.phone, this.message);
}

final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
