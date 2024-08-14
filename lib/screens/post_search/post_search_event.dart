part of 'post_search_bloc.dart';

@immutable
sealed class PostSearchEvent {}

class NewPostSearch extends PostSearchEvent {
  int pageKey, pageSize;
  String? searchQuery;
  NewPostSearch(this.pageKey, this.pageSize, this.searchQuery);
}


class NewUserSearch extends PostSearchEvent {
  String? searchQuery;
  NewUserSearch(this.searchQuery);
}
