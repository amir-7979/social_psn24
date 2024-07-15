part of 'verify_bloc.dart';

@immutable
sealed class VerifyEvent {}

class VerifyTokenEvent extends VerifyEvent {
  String code;
  String loginId;

  VerifyTokenEvent({required this.code, required this.loginId});
}

class ResendCode extends VerifyEvent {
  String phone;
  ResendCode({required this.phone});
}
