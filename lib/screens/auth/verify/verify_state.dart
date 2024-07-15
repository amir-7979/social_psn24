part of 'verify_bloc.dart';

@immutable
sealed class VerifyState {}

final class VerifyInitial extends VerifyState {}

final class VerifyLoading extends VerifyState {}

final class VerifySuccess extends VerifyState {}

final class VerifyFailure extends VerifyState {
  final String error;
  VerifyFailure(this.error);
}

class VerifyFinished extends VerifyState {
  VerifyFinished();
}

class ResendSuccess extends VerifyState {
  String loginId;
  ResendSuccess(this.loginId);
}

class ResendFailure extends VerifyState {
  final String error;
  ResendFailure(this.error);
}
