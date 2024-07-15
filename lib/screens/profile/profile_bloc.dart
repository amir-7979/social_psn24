import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/comment.dart';
import '../../repos/models/content.dart';
import '../../repos/models/profile.dart';
import '../../repos/models/user_permissions.dart';
import '../../repos/repositories/profile_repository.dart';
import '../../services/core_graphql_service.dart';
import '../../services/graphql_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;

  ProfileBloc(this.settingBloc) : super(ProfileInitial()) {
    on<FetchProfile>(fetchProfile);
    on<FetchProfileForEditScreen>(fetchProfileForEditScreen);
    on<NavigateToEditProfile>(navigateToEditProfile);
    on<NavigateToInitialScreen>(navigateToInitialScreen);
    on<EditProfile>(handleEditProfileEvent);
    on<DeletePost>(handleDeletePost);
    on<ChangeStatusEvent>(handleChangeStatusEvent);
  }

  Future<void> handleDeletePost(event, emit) async {
    emit(PostDeleting(event.postId));
    try {
      final MutationOptions options = deletePost(event.postId);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(PostDeleteFailure(result.exception.toString()));
      } else {
        emit(PostDeleteSuccess());
      }
    } catch (e) {
      emit(PostDeleteFailure(e.toString()));
    }
  }

  FutureOr<void> navigateToInitialScreen(event, emit) {
    emit(NavigationToProfileScreenState());
  }

  FutureOr<void> fetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      final QueryOptions options = getUserProfile(event.id);

      final QueryResult result = await coreGraphQLService.query(options);
      if (result.data == null) {
        emit(ProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      await Future.delayed(Duration(seconds: 2));
      final Map<String, dynamic> data = result.data!;
      final Profile profile = Profile.fromJson(data['profile']);
      emit(ProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(ProfileError('خطا در دریافت اطلاعات'));
    }
  }

  FutureOr<void> fetchProfileForEditScreen(FetchProfileForEditScreen event, Emitter<ProfileState> emit) async {
    emit(NewProfileInfoLoading());
    try {
      final QueryOptions options = getUserProfile(event.id);

      final QueryResult result = await coreGraphQLService.query(options);
      if (result.data == null) {
        emit(NewProfileError('خطا در دریافت اطلاعات'));
        return;
      }
      final Map<String, dynamic> data = result.data!;
      final Profile profile = Profile.fromJson(data['profile']);
      emit(NewProfileInfoLoaded(profile: profile));
    } catch (exception) {
      emit(NewProfileError('خطا در دریافت اطلاعات'));
    }
  }

  FutureOr<void> handleEditProfileEvent(EditProfile event, Emitter<ProfileState> emit) async {
    emit(EditProfileInfoLoading());
    try {
      final MutationOptions options = editUser(
        event.name,
        event.family,
        "@${event.username}",
        event.photoUrl,
        event.biography,
        event.experience,
      );
      final QueryResult result = await coreGraphQLService.mutate(options);
      if (result.hasException) {
        emit(EditProfileError('خطا در ثبت اطلاعات'));
        return;
      }

      emit(EditProfileInfoLoaded());
    } catch (exception) {
      print(exception.toString());
      emit(EditProfileError('خطا در ثبت اطلاعات'));
    }
  }

  static Future<void> fetchContent(PagingController<int, Content> pagingController, int postType, int limit, int? userId) async {
    try {
      final QueryOptions options = getUserPosts(postType, limit, pagingController.nextPageKey!, userId);
      final QueryResult result = await GraphQLService.instance.client.query(options);
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
      print('here');
      final QueryOptions options = getCommentsWithPostData(postId, userId, type, limit, pagingController.nextPageKey!);
      final QueryResult result = await GraphQLService.instance.client.query(options);
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

  void navigateToEditProfile(NavigateToEditProfile event, Emitter<ProfileState> emit) {
    emit(NavigationToEditScreenState());
  }

  Future<FutureOr<void>> handleChangeStatusEvent(ChangeStatusEvent event, Emitter<ProfileState> emit) async {
    try {
      final MutationOptions options = changeOnlineStatus();
      final QueryResult result = await coreGraphQLService.mutate(options);
      if (result.hasException) {
        print(result.exception.toString());
      } else {
        print(result.data.toString());

      }
    } catch (e) {
      print(e.toString());
    }
  }


}