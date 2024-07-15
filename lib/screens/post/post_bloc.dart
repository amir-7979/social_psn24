import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../repos/models/comment.dart';
import '../../repos/repositories/post_repository.dart';
import '../../services/graphql_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  GraphQLClient graphQLService = GraphQLService.instance.client;

  PostBloc() : super(PostInitial()) {
    on<AddToInterestEvent>(_onAddToInterestEvent);
    on<EnableNotificationEvent>(_onEnableNotificationEvent);
    on<UserVoteUpEvent>(_onUserVoteUpEvent);
    on<UserVoteDownEvent>(_onUserVoteDownEvent);
  }

  FutureOr<void> _onAddToInterestEvent(AddToInterestEvent event, Emitter<PostState> emit) async {
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

  FutureOr<void> _onEnableNotificationEvent(EnableNotificationEvent event, Emitter<PostState> emit) async {
    try {
      final MutationOptions options = enableNotification(event.postId);
      final QueryResult result = await graphQLService.mutate(options);
      print(result.data);
      if (result.hasException) {
        emit(NotificationFailureState());
      } else {
        emit(NotificationSuccessState());
      }
    } catch (e) {
      emit(NotificationFailureState());
    }
  }

  FutureOr<void> _onUserVoteUpEvent(UserVoteUpEvent event, Emitter<PostState> emit) async {
    try {
      final MutationOptions options = votePost(postId: event.postId, type: event.voteType);
      final QueryResult result = await graphQLService.mutate(options);
      print(result.data);
      if (result.hasException) {
        emit(UserVoteUpFailureState());
      } else {
        emit(UserVoteUpSuccessState());
      }
    } catch (e) {
      emit(UserVoteUpFailureState());
    }
  }

  FutureOr<void> _onUserVoteDownEvent(UserVoteDownEvent event, Emitter<PostState> emit) async {
    try {
      final MutationOptions options = votePost(postId: event.postId, type: event.voteType);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(UserVoteDownFailureState());
      } else {
        emit(UserVoteDownSuccessState());
      }
    } catch (e) {
      emit(UserVoteDownFailureState());
    }
  }

  static Future<void> fetchComments(PagingController<int, Comment> pagingController, String postId, int limit, String? postType) async {
    try {
      final QueryOptions options = getComments(postId: postId, limit: limit, offset: pagingController.nextPageKey, type: postType);
      final QueryResult result = await GraphQLService.instance.client.query(options);
      if (result.hasException) {
        print(result.exception);
        pagingController.error = result.exception;
      }
      print(result.data);
      final List<Comment> posts = (result.data?['comments'] as List<dynamic>?)
          ?.map((dynamic item) => Comment.fromJson(item as Map<String, dynamic>)).toList() ?? [];
      final isLastPage = posts.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(posts);
      } else {
        final nextPageKey = pagingController.nextPageKey! + posts.length;
        pagingController.appendPage(posts, nextPageKey);
      }
    } catch (error) {
      try {
        print(error);
        pagingController.error = error;
      } catch (e) {
        print(e.toString());
      }
    }
  }

}
