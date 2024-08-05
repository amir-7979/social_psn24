part of 'create_post_bloc.dart';

@immutable
sealed class CreatePostState {}

final class CreateMediaInitial extends CreatePostState {}

final class CreatingNewPost extends CreatePostState {}

final class PostCreationFailed extends CreatePostState {
  final String message;
  PostCreationFailed(this.message);
}

final class PostCreationSucceed  extends CreatePostState {
  final CreateNewPost postCreated;
  PostCreationSucceed(this.postCreated);
}

final class MediaUploading extends CreatePostState {}

final class MediaUploaded extends CreatePostState {
  final PostMedia postMedia;

  MediaUploaded(this.postMedia);
}

final class MediaUploadFailed extends CreatePostState {
  final String message;
  MediaUploadFailed(this.message);
}

final class MediaDeleting extends CreatePostState {
  final String mediaId;
  MediaDeleting(this.mediaId);
}

final class MediaDeleted extends CreatePostState {
  final String mediaId;
  MediaDeleted(this.mediaId);
}

final class MediaDeleteFailed extends CreatePostState {
  final String message;
  MediaDeleteFailed(this.message);
}

final class MediaOrderChanged extends CreatePostState {}

final class MediaOrderChangeFailed extends CreatePostState {
  final String message;
  MediaOrderChangeFailed(this.message);
}

final class SubmittingPostLoading extends CreatePostState {}

final class SubmittingCreateSucceed extends CreatePostState {}

final class  SubmittingCreateFailed extends CreatePostState {
  final String message;

  SubmittingCreateFailed(this.message);
}