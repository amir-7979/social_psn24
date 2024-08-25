part of 'appbar_bloc.dart';

@immutable
sealed class AppbarState {}

final class AppbarInitial extends AppbarState {}

final class Searching extends AppbarState {
  final String title;
  Searching(this.title);
}

final class NotSearching extends AppbarState {}


