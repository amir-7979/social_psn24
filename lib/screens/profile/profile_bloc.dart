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
    on<FetchProfile>(fetchProfile);
    on<FetchProfileForEditScreen>(fetchProfileForEditScreen);
    on<EditProfile>(handleEditProfileEvent);
    on<DeletePost>(handleDeletePost);
   /* on<ChangeStatusEvent>(handleChangeStatusEvent);
    on<ToggleNotificationEvent>(handleToggleNotificationEvent);*/
  }


  // Fetch Profile
  FutureOr<void> fetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      Response result = await profileRepository.getProfile();
      if (result.data == null) {
        emit(ProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      final Profile profile = Profile.fromJson(result.data['profile']);
      emit(ProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(ProfileError('خطا در دریافت اطلاعات'));
    }
  }

  // Fetch Profile for Edit Screen
  FutureOr<void> fetchProfileForEditScreen(FetchProfileForEditScreen event, Emitter<ProfileState> emit) async {
    emit(NewProfileInfoLoading());
    try {
      Response result = await profileRepository.getProfile();
      if (result.data == null) {
        emit(NewProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      final Profile profile = Profile.fromJson(result.data['profile']);
      emit(NewProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(NewProfileError('خطا در دریافت اطلاعات'));
    }
  }

  // Handle Edit Profile Event
  FutureOr<void> handleEditProfileEvent(EditProfile event, Emitter<ProfileState> emit) async {
    emit(EditProfileInfoLoading());
    try {
      Response result = await profileRepository.updateProfile(
        firstName: event.name!,
        lastName: event.family!,
        username: event.username,
        photo: event.photoUrl,
      );
      emit(EditProfileInfoLoaded());
    } catch (exception) {
      emit(EditProfileError('خطا در ثبت اطلاعات'));
    }
  }
/*
  // Handle Change Status Event (You may add it to ProfileRepository)
  FutureOr<void> handleChangeStatusEvent(ChangeStatusEvent event, Emitter<ProfileState> emit) async {
    try {
      Response result = await profileRepository.changeStatus();
      emit(ChangeOnlineStatusSucceed(result.data['status']));
    } catch (e) {
      emit(ChangeOnlineStatusFailed());
    }
  }

  // Handle Toggle Notification Event (You may add it to ProfileRepository)
  Future<void> handleToggleNotificationEvent(ToggleNotificationEvent event, Emitter<ProfileState> emit) async {
    emit(TogglingNotificationState());
    try {
      Response result = await profileRepository.toggleNotification(event.id);
      emit(ToggleNotificationSuccess());
    } catch (e) {
      emit(ToggleNotificationFailure('خطا در عملیات'));
    }
  }
  */
  static Future<void> fetchContent(PagingController<int, Content> pagingController, int postType, int limit, int? userId) async {
    try {
      final gql.QueryOptions options = getUserPosts(postType, limit, pagingController.nextPageKey!, userId);
      final gql.QueryResult result = await GraphQLService.instance.client.query(options);
      final List<Content> contents = (result.data?['mycontents'] as List<dynamic>?)
          ?.map((dynamic item) => Content.fromJson(item as Map<String, dynamic>)).toList() ?? [];
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

  static Future<void> fetchComment(PagingController<int, Comment> pagingController, String? postId, int? userId, String type, int limit) async {
    try {
      final gql.QueryOptions options = getCommentsWithPostData(postId: postId, userId: userId, type: type, limit: limit, offset: pagingController.nextPageKey!);
      final gql.QueryResult result = await GraphQLService.instance.client.query(options);
      if (result.hasException) {
        print(result.exception.toString());
      }
      final List<Comment> comments = (result.data?['comments'] as List<dynamic>?)
          ?.map((dynamic item) => Comment.fromJson(item as Map<String, dynamic>)).toList() ?? [];
      final isLastPage = comments.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(comments);
      } else {
        final nextPageKey = pagingController.nextPageKey! + comments.length;
        pagingController.appendPage(comments, nextPageKey);
      }
    } catch (error) {
      try {
        print(error.toString());
        pagingController.error = error;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> handleDeletePost(event, emit) async {
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
}
