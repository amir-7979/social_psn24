part of 'post_search_bloc.dart';

@immutable
sealed class PostSearchState {}

final class PostSearchInitial extends PostSearchState {}

final class TagsLoadedState extends PostSearchState {
  List<Tag> tags;
  int pageKey;
  TagsLoadedState(this.tags, this.pageKey);
}
final class TagsErrorState extends PostSearchState {
  final String error;
  TagsErrorState(this.error);
}

final class UserLoadedState extends PostSearchState {
  List<Profile> users;
  UserLoadedState(this.users);
}
final class UserErrorState extends PostSearchState {
  final String error;
  UserErrorState(this.error);
}
