part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostEvent {}


class ChangeMediaOrderEvent extends CreatePostEvent {
  final int oldIndex;
  final int newIndex;

  ChangeMediaOrderEvent({required this.oldIndex, required this.newIndex});
}

class CreateNewPostEvent extends CreatePostEvent {}
class EditPostEvent extends CreatePostEvent {}

class ResetCategoryEvent extends CreatePostEvent {
  final bool type;
  ResetCategoryEvent(this.type);
}

class SubmitNewPostEvent extends CreatePostEvent {
  final String title;
  final String category;
  final String longText;
  final int? status, publish, postType;


  SubmitNewPostEvent({
    required this.title,
    required this.category,
    required this.longText,
    this.status,
    this.publish,
    this.postType,
  });
}

class GetMediasEvent extends CreatePostEvent {}

class AddItemEvent extends CreatePostEvent {
  final Media media;
  AddItemEvent(this.media);
}

class RemoveItemEvent extends CreatePostEvent {
  final String mediaId;
  RemoveItemEvent(this.mediaId);
}

class RebuildMediaListEvent extends CreatePostEvent {}




