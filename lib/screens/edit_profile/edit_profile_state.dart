part of 'edit_profile_bloc.dart';

@immutable
sealed class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileError extends EditProfileState {
  final String message;

  EditProfileError(this.message);
}

class EditProfileSuccess extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

