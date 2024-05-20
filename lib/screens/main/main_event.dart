part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainUpdate extends MainEvent {
  final int index;
  MainUpdate(this.index);
}

class CooperatingClicked extends MainEvent {}