import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../repos/models/comment.dart';
import '../../repos/models/post.dart';
import '../../repos/repositories/graphql/post_repository.dart';
import '../../services/graphql_service.dart';

part 'post_detailed_event.dart';
part 'post_detailed_state.dart';

class PostDetailedBloc extends Bloc<PostDetailedEvent, PostDetailedState> {
  GraphQLClient graphQLService = GraphQLService.instance.client;

  PostDetailedBloc() : super(PostDetailedInitial()) {
    on<AddToInterestEvent>(_onAddToInterestEvent);
    on<EnableNotificationEvent>(_onEnableNotificationEvent);
    on<UserVoteUpEvent>(_onUserVoteUpEvent);
    on<UserVoteDownEvent>(_onUserVoteDownEvent);
    on<CreateCommentEvent>(_onCreateCommentEvent);
    on<IncreasePostViewEvent>(_onIncreasePostView);
    on<FetchPostEvent>(_onFetchPostEvent);

  }

  Future<void> _onFetchPostEvent(FetchPostEvent event, Emitter<PostDetailedState> emit) async {
    try {
      emit(PostLoading());
      final QueryOptions options = postsQuery(id: event.postId);
      final QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        emit(PostFetchFailure('خطا در دریافت اطلاعات'));
      } else {
        final Post post = Post.fromJson(result.data?['posts'][0]);
        emit(PostFetchSuccess(post));
      }
    } catch (e) {
      emit(PostFetchFailure('خطا در دریافت اطلاعات'));
    }
  }

  Future<void> _onAddToInterestEvent(
      AddToInterestEvent event, Emitter<PostDetailedState> emit) async {
    try {
      final MutationOptions options = likePost(event.itemId);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(InterestFailureState());
      } else {
        emit(InterestSuccessState());
      }
    } catch (e) {
      emit(InterestFailureState());
    }
  }

  Future<void> _onEnableNotificationEvent(
      EnableNotificationEvent event, Emitter<PostDetailedState> emit) async {
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

  Future<void> _onUserVoteUpEvent(
      UserVoteUpEvent event, Emitter<PostDetailedState> emit) async {
    try {
      final MutationOptions options =
          votePost(postId: event.postId, type: event.voteType);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(UserVoteUpFailureState());
      } else {
        emit(UserVoteUpSuccessState());
      }
    } catch (e) {
      emit(UserVoteUpFailureState());
    }
  }

  Future<void> _onUserVoteDownEvent(
      UserVoteDownEvent event, Emitter<PostDetailedState> emit) async {
    try {
      final MutationOptions options =
          votePost(postId: event.postId, type: event.voteType);
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

  Future<void> _onCreateCommentEvent(
      CreateCommentEvent event, Emitter<PostDetailedState> emit) async {
    emit(CreatingComment());
    try {
      final MutationOptions options = createComment(
          postId: event.postId, replyTo: event.replyId, message: event.message);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(CommentFailure(error: result.exception.toString()));
      } else {
        emit(CommentCreated(message: ''));
        emit(CommentCountRefresh());
        emit(CommentListRefresh());
      }
    } catch (e) {
      emit(CommentFailure(error: e.toString()));
    }
  }

  static Future<void> fetchComments(
      PagingController<int, Comment> pagingController,
      String postId,
      int limit,
      String? postType) async {
    try {
      final QueryOptions options = getComments(
          postId: postId,
          limit: limit,
          offset: pagingController.nextPageKey,
          type: postType);
      final QueryResult result =
          await GraphQLService.instance.client.query(options);
      if (result.hasException) {
        pagingController.error = result.exception;
      }
      final List<Comment> posts = (result.data?['comments'] as List<dynamic>?)
              ?.map((dynamic item) =>
                  Comment.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [];
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

  Future<void> _onIncreasePostView(
    IncreasePostViewEvent event,
    Emitter<PostDetailedState> emit,
  ) async {
    final MutationOptions options = increasePostView(
      id: event.postId,
      viewCount: event.viewCount,
      status: event.status,
    );
    var response = await graphQLService.mutate(options);
    if (response.hasException) {
    } else {
      print(response.data);
    }
    //todo ask ashkan
  }
}
