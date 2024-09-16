import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../repos/models/profile.dart';
import '../../repos/models/tag.dart';
import '../../repos/repositories/graphql/post_repository.dart';
import '../../services/graphql_service.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  GraphQLClient graphQLService = GraphQLService.instance.client;

  PostSearchBloc() : super(PostSearchInitial()) {
    on<NewPostSearch>(_handlePostSearch);
    on<NewUserSearch>(_handleUserSearch);
  }

  void _handlePostSearch(NewPostSearch event, Emitter<PostSearchState> emit) async {
    try {
      final QueryOptions options = getTags(search: event.searchQuery, limit: event.pageSize, offset: event.pageKey);
      final QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        print(result.exception);
        emit(TagsErrorState(result.exception.toString()));
        return;
      }
      final List<Tag> tags = (result.data?['tags'] as List<dynamic>?)
          ?.map((dynamic item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList() ?? [];
      emit(TagsLoadedState(tags,event.pageKey));
    } catch (e) {
      print(e.toString());
      emit(TagsErrorState(e.toString()));
    }
  }


  void _handleUserSearch(NewUserSearch event, Emitter<PostSearchState> emit) async {
    try {
      final QueryOptions options = searchUser(search: event.searchQuery);
      final QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        emit(UserErrorState(result.exception.toString()));
        return;
      }
      final List<Profile> users = (result.data?['currentUser'] as List<dynamic>?)
          ?.map((dynamic item) => Profile.fromJson(item as Map<String, dynamic>))
          .toList() ?? [];
      emit(UserLoadedState(users));
    } catch (e) {
      print(e.toString());
      emit(UserErrorState(e.toString()));
    }
  }
}
