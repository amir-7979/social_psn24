part of 'create_media_bloc.dart';

@immutable
sealed class CreateMediaState {}

final class CreateMediaInitial extends CreateMediaState {}

final class CreateMediaLoading extends CreateMediaState {}
