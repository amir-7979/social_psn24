part of 'main_bloc.dart';

class MainState{
  final int index;
  MainState(this.index);
}

class CooperatingState extends MainState {
  CooperatingState() : super(2);
}