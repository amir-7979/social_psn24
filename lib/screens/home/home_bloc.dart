import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/services/core_graphql_service.dart';
import 'package:social_psn/services/graphql_service.dart';

import '../../repos/models/post.dart';
import '../../repos/repositories/post_repository.dart';
import '../../services/no_auth_graphql_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
   GraphQLClient graphQLService = GraphQLService.instance.client;
   GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;

  HomeBloc() : super(HomeInitialState()) {
    on<RefreshPostsEvent>(_onRefreshPostsEvent);
    on<AddToInterestEvent>(_onAddToInterestEvent);
    on<EnableNotificationEvent>(_onEnableNotificationEvent);

  }

  Future<void> _onRefreshPostsEvent(RefreshPostsEvent event, Emitter<HomeState> emit) async {
    emit(PostRefreshSuccess());
  }

  static Future<void> fetchPosts(PagingController<int, Post> pagingController, int limit, int? postType, String? id, int? isPublish, int? tagId, String? search, int? offset) async {
  try {
    final QueryOptions options = postsQuery(id: id, isPublish: isPublish, tagId: tagId, search: search, limit: limit, offset: pagingController.nextPageKey, postType: postType);
    final QueryResult result = await NoAuthGraphQLService.instance.client.query(options);
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

   FutureOr<void> _onAddToInterestEvent(AddToInterestEvent event, Emitter<HomeState> emit) async {
     try {
       final MutationOptions options = likePost(event.itemId);
       final QueryResult result = await graphQLService.mutate(options);
       if (result.hasException) {
         emit(InterestFailureState());
       } else {
         print(result.data);
         emit(InterestSuccessState());
       }
     } catch (e) {
       emit(InterestFailureState());
     }
   }

   FutureOr<void> _onEnableNotificationEvent(EnableNotificationEvent event, Emitter<HomeState> emit) async {
     try {
       final MutationOptions options = enableNotification(event.postId);
       final QueryResult result = await graphQLService.mutate(options);
       if (result.hasException) {
         emit(NotificationFailureState());
       } else {
         emit(NotificationSuccessState());
       }
     } catch (e) {
       emit(NotificationFailureState());
     }
   }
}