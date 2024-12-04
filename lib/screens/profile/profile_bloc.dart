import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as gql;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/comment.dart';
import '../../repos/models/content.dart';
import '../../repos/models/profile.dart';
import '../../repos/repositories/dio/dio_profile_repository.dart';
import '../../repos/repositories/graphql/post_repository.dart';
import '../../services/graphql_service.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository = ProfileRepository();
  final gql.GraphQLClient graphQLService = GraphQLService.instance.client;
  final SettingBloc settingBloc;

  ProfileBloc(this.settingBloc) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfileEvent);
    on<FetchMyProfileEvent>(_onFetchMyProfileEvent);
    on<DeletePostEvent>(_onDeletePostEvent);
    on<EditPostEvent>(_onEditPostEvent);
    on<ChangeToPostEvent>(_onChangeToPostEvent);
    on<ChangeToCommentEvent>(_onChangeToCommentEvent);
    on<ChangeStatusEvent>(handleChangeStatusEvent);
    on<ToggleNotificationEvent>(handleToggleNotificationEvent);
    on<FetchMyActivityEvent>(_onFetchMyActivityEvent);
    on<ProfileRefreshRequested>(_onProfileRefreshRequested);
  }

  FutureOr<void> _onFetchProfileEvent(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      final gql.QueryOptions options = getUserProfile(event.id);
      final gql.QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        emit(ProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      final Map<String, dynamic> data = result.data!;
      final Profile profile = Profile.fromJson(data['profile']);
      emit(ProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(ProfileError('خطا در دریافت اطلاعات'));
    }
  }

  Future<void> _onFetchMyProfileEvent(
      FetchMyProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      Response result = await profileRepository.getProfile();
      if (result.data == null) {
        emit(ProfileError('خطا در دریافت اطلاعات'));
      }
      final Profile profile = Profile.fromJson(result.data['data']);
      emit(ProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(ProfileError('خطا در دریافت اطلاعات'));
    }
  }

  Future<void> _onFetchMyActivityEvent(
      FetchMyActivityEvent event, Emitter<ProfileState> emit) async {
    try {
      final gql.QueryOptions options = getUserActivities(event.id!);
      final gql.QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        emit(activityFailureState('خطا در دریافت اطلاعات'));
      }
      final Map<String, dynamic> data = result.data!['profile'];
      emit(activitySuccessState(data));
    } catch (exception) {
      emit(activityFailureState('خطا در دریافت اطلاعات'));
    }
  }

  static Future<void> fetchContent(
      PagingController<int, Content> pagingController,
      int postType,
      int limit,
      int? userId) async {
    try {
      final gql.QueryOptions options =
          getUserPosts(postType, limit, pagingController.nextPageKey!, userId);
      final gql.QueryResult result =
          await GraphQLService.instance.client.query(options);
      if (result.hasException) {
      }
      final List<Content> contents =
          (result.data?['mycontents'] as List<dynamic>?)
                  ?.map((dynamic item) =>
                      Content.fromJson(item as Map<String, dynamic>))
                  .toList() ??
              [];
      final isLastPage = contents.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(contents);
      } else {
        final nextPageKey = pagingController.nextPageKey! + contents.length;
        pagingController.appendPage(contents, nextPageKey);
      }
    } catch (error) {
      try {
        pagingController.error = error;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  static Future<void> fetchComment(
      PagingController<int, Comment> pagingController,
      String? postId,
      int? userId,
      String type,
      int limit) async {
    try {
      final gql.QueryOptions options = getCommentsWithPostData(
          postId: postId,
          userId: userId,
          type: type,
          limit: limit,
          offset: pagingController.nextPageKey!);
      final gql.QueryResult result =
          await GraphQLService.instance.client.query(options);
      if (result.hasException) {
      }
      final List<Comment> comments =
          (result.data?['comments'] as List<dynamic>?)
                  ?.map((dynamic item) =>
                      Comment.fromJson(item as Map<String, dynamic>))
                  .toList() ??
              [];
      final isLastPage = comments.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(comments);
      } else {
        final nextPageKey = pagingController.nextPageKey! + comments.length;
        pagingController.appendPage(comments, nextPageKey);
      }
    } catch (error) {
      try {
        pagingController.error = error;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _onDeletePostEvent(event, emit) async {
    emit(PostDeleting(event.postId));
    try {
      final gql.MutationOptions options = deletePost(event.postId);
      final gql.QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(PostDeleteFailure(result.exception.toString()));
      } else {
        emit(PostDeleteSuccess());
      }
    } catch (e) {
      emit(PostDeleteFailure(e.toString()));
    }
  }

  void _onChangeToPostEvent(
          ChangeToPostEvent event, Emitter<ProfileState> emit) =>
      emit(ChangeToPostState());

  void _onChangeToCommentEvent(
          ChangeToCommentEvent event, Emitter<ProfileState> emit) =>
      emit(ChangeToCommentState());

  FutureOr<void> _onEditPostEvent(
      EditPostEvent event, Emitter<ProfileState> emit) {}

  // Fetch Profile
  /*FutureOr<void> fetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      Response result = await profileRepository.getProfile();
      if (result.data == null) {
        emit(ProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      final Profile profile = Profile.fromJson(result.data['data']);
      emit(ProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(ProfileError('خطا در دریافت اطلاعات'));
    }
  }*/

  FutureOr<void> handleChangeStatusEvent(
      ChangeStatusEvent event, Emitter<ProfileState> emit) async {
    try {
      Response result =
          await profileRepository.editOnlineStatus(status: event.status, name: event.name, family: event.family);
      if (result.data == null) {
        emit(ChangeOnlineStatusFailed());
        return;
      }
      emit(ChangeOnlineStatusSucceed(result.data['data']['show_activity']));
    } catch (exception) {
      print(exception.toString());

      emit(ChangeOnlineStatusFailed());
    }
  }

  Future<void> handleToggleNotificationEvent(
      ToggleNotificationEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(TogglingNotificationState());
      final gql.MutationOptions options = enableUserNotification(event.id);
      final gql.QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(ToggleNotificationFailure('خطا در عملیات'));
      } else {
        emit(ToggleNotificationSuccess());
      }
    } catch (e) {

      emit(ToggleNotificationFailure('خطا در عملیات'));
    }
  }

  FutureOr<void> _onProfileRefreshRequested(ProfileRefreshRequested event, Emitter<ProfileState> emit) {
    emit(ProfileInfoRefreshState());
    emit(ProfileContentRefreshState());
  }
}
