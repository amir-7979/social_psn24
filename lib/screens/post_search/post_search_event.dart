part of 'post_search_bloc.dart';

@immutable
sealed class PostSearchEvent {}

class PostSearch extends PostSearchEvent {
  int pageKey, pageSize;
  String? searchQuery;
  PostSearch(this.pageKey, this.pageSize, this.searchQuery);
}


class UserSearch extends PostSearchEvent {
  String? searchQuery;
  UserSearch(this.searchQuery);
}
