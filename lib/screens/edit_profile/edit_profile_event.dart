part of 'edit_profile_bloc.dart';

@immutable
sealed class EditProfileEvent {}

class SubmitEditProfileEvent extends EditProfileEvent {
  final String name;
  final String family;
  final String? username;

  SubmitEditProfileEvent({
    required this.name,
    required this.family,
    required this.username,
  });
}