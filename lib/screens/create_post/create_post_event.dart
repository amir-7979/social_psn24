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