import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/services/graphql_service.dart';

import '../../repos/models/post.dart';
import '../../repos/repositories/post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
   GraphQLClient graphQLService = GraphQLService.instance.client;

  HomeBloc() : super(HomeInitialState()) {
    on<RefreshPostsEvent>(_onRefreshPostsEvent);
    on<RefreshIndexEvent>(_onRefreshIndexEvent);
    on<SearchPostsEvent>(_onSearchPostsEvent);

  }
   Future<void> _onRefreshIndexEvent(RefreshIndexEvent event, Emitter<HomeState> emit) async {
     emit(goToDetailedPostState(event.post));
   }

  Future<void> _onRefreshPostsEvent(RefreshPostsEvent event, Emitter<HomeState> emit) async {
    emit(PostRefreshSuccess());
  }

  static Future<void> fetchPosts(PagingController<int, Post> pagingController, int limit, int? postType, String? id, int? isPublish, String? tagId, String? search) async {
  try {
    final QueryOptions options = postsQuery(id: id, isPublish: isPublish, tagId: tagId, search: search, limit: limit, offset: pagingController.nextPageKey, postType: postType);
    final QueryResult result = await GraphQLService.instance.client.query(options);
    if (result.hasException) {
      pagingController.error = result.exception;
    }
    final List<Post> posts = (result.data?['posts'] as List<dynamic>?)
        ?.map((dynamic item) => Post.fromJson(item as Map<String, dynamic>)).toList() ?? [];

    final isLastPage = posts.length < limit;
    if (isLastPage) {
      pagingController.appendLastPage(posts);
    } else {
      final nextPageKey = pagingController.nextPageKey! + posts.length;
      pagingController.appendPage(posts, nextPageKey);
    }
  } catch (error) {
    try {
      pagingController.error = error;
    } catch (e) {
      print(e.toString());
    }
  }
}


  FutureOr<void> _onSearchPostsEvent(SearchPostsEvent event, Emitter<HomeState> emit) {
    emit(SearchParams(event.query, event.tag, event.type));
  }
}