part of 'appbar_bloc.dart';

@immutable
sealed class AppbarEvent {}

final class AppbarSearch extends AppbarEvent {
  final String title;
  AppbarSearch(this.title);
}

final class AppbarResetSearch extends AppbarEvent {
}