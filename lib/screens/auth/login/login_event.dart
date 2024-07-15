part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LogInEvent extends LoginEvent {
  final String phoneNumber;
  LogInEvent(this.phoneNumber);
}

