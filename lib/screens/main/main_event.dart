part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainUpdate extends MainEvent {
  final int index;
  MainUpdate(this.index);
}

class CooperatingClicked extends MainEvent {}

class AuthenticationClicked extends MainEvent {}

class InterestClicked extends MainEvent {}

class CreateMedia extends MainEvent {}

class LogoutClicked extends MainEvent {} // New event for logout