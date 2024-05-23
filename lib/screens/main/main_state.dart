part of 'main_bloc.dart';

class MainState{
  final int index;
  MainState(this.index);
}

class CooperatingState extends MainState {
  CooperatingState() : super(2);
}

class AuthenticationState extends MainState {
  AuthenticationState() : super(2);
}

class InterestState extends MainState {
  InterestState() : super(2);
}

class LogoutState extends MainState { // New state for logout
  LogoutState() : super(1);
}