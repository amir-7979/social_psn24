part of 'profile_attachment_bloc.dart';

@immutable
abstract class ProfileAttachmentState {}

class ProfileAttachmentInitial extends ProfileAttachmentState {}

class ProfileAttachmentLoading extends ProfileAttachmentState {}

class ProfileAttachmentSuccess extends ProfileAttachmentState {
  final String imageUrl;

  ProfileAttachmentSuccess(this.imageUrl);
}
class ProfileAttachmentRemove extends ProfileAttachmentState {}

class ProfileAttachmentFailure extends ProfileAttachmentState {
  final String? error;

  ProfileAttachmentFailure(this.error);
}