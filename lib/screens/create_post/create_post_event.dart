part of 'create_post_bloc.dart';

@immutable
abstract class CreatePostEvent {}


class ChangeMediaOrderEvent extends CreatePostEvent {
  final List<String> newOrder;
  final String postId;

  ChangeMediaOrderEvent(this.newOrder, this.postId);
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

class GetMediasEvent extends CreatePostEvent {}




