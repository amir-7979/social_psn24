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
  final Post post;
  final AdminSettings adminSettings;
  PostCreationSucceed({required this.post, required this.adminSettings});
}

final class MediaOrderChanged extends CreatePostState {}

final class MediaOrderChangeFailed extends CreatePostState {
  final String message;
  MediaOrderChangeFailed(this.message);
}

final class SubmittingPostLoading extends CreatePostState {}

final class SubmittingCreateSucceed extends CreatePostState {}

final class  SubmittingFailed extends CreatePostState {
  final String message;

  SubmittingFailed(this.message);
}

final class ResetCategoryState extends CreatePostState {final bool type; ResetCategoryState(this.type);}


final class CancelUploadMediaEvent extends CreatePostEvent {
  final File mediaFile;
  CancelUploadMediaEvent(this.mediaFile);
}

final class RebuildMediaListState extends CreatePostState {}
