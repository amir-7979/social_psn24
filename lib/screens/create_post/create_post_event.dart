part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostEvent {}

class UploadMediaEvent extends CreatePostEvent {
  final File mediaFile;
  UploadMediaEvent(this.mediaFile);
}

class DeleteMediaEvent extends CreatePostEvent {
  final String mediaId;
  DeleteMediaEvent(this.mediaId);
}

class ChangeMediaOrderEvent extends CreatePostEvent {
  final List<String> newOrder;

  ChangeMediaOrderEvent(this.newOrder);
}

class CreateNewPostEvent extends CreatePostEvent {}

class ResetCategoryEvent extends CreatePostEvent {}

class SubmitNewPostEvent extends CreatePostEvent {
  final String title;
  final String category;
  final String longText;

  SubmitNewPostEvent({
    required this.title,
    required this.category,
    required this.longText,
  });
}
