import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meta/meta.dart';

import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/comment.dart';
import '../../repos/models/content.dart';
import '../../repos/models/liked.dart';
import '../../repos/models/user_permissions.dart';
import '../../repos/models/profile.dart';
import '../../repos/repositories/profile_repository.dart';
import '../../services/core_graphql_service.dart';
import '../../services/graphql_service.dart';
import '../../services/storage_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final GraphQLClient coreGraphQLService = CoreGraphQLService.instance.client;
  final SettingBloc settingBloc;

  ProfileBloc(this.settingBloc) : super(ProfileInitial()) {
    on<FetchProfile>(fetchProfile);
    on<NavigateToEditProfile>(navigateToEditProfile);
    on<NavigateToInitialScreen>(navigateToInitialScreen);
    on<EditProfile>(handleEditProfileEvent);

  }

  FutureOr<void> navigateToInitialScreen(event, emit) {
    emit(ProfileInitial());
  }

  FutureOr<void> fetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileInfoLoading());
    try {
      final QueryOptions options = getUserProfileWithPermissions(event.id);
      final QueryResult result = await coreGraphQLService.query(options);
      if (result.data == null) {
        emit(ProfileError('No data found'));
        return;
      }

      final Map<String, dynamic> data = result.data!;
      print(data.isNotEmpty);
      final Profile profile = Profile.fromJson(data['profile']);
      final UserPermissions userPermissions = UserPermissions.fromJson(data['userPermissions']);
      if(event.id != null){
        settingBloc.add(UpdateUserPermissions(userPermissions));
        if (userPermissions.isExpert != null) {
          final storageService = StorageService();
          await storageService.saveData('isExpert', userPermissions.isExpert.toString());
          settingBloc.add(UpdateIsExpert(userPermissions.isExpert!));
        }
      }
      emit(ProfileInfoLoaded(profile: profile, userPermissions: userPermissions));
    } catch (exception) {
      print(exception.toString());
      emit(ProfileError(exception.toString()));
    }
  }

  FutureOr<void> handleEditProfileEvent(EditProfile event, Emitter<ProfileState> emit) async {
    emit(EditProfileInfoLoading());
    try {
      final MutationOptions options = editUser(
        event.name,
        event.family,
        event.photo,
        event.biography,
        event.field,
        event.experience,
        event.address,
        event.office,
        event.showActivity,
        event.username,
      );
      final QueryResult result = await coreGraphQLService.mutate(options);
      print(result.data.toString());
      if (result.data == null) {
        emit(EditProfileError());
        return;
      }

      final Map<String, dynamic> data = result.data!;
      final Profile profile = Profile.fromJson(data['editUser']);
      emit(EditProfileInfoLoaded(profile: profile, userPermissions: null));
    } catch (exception) {
      print(exception.toString());
      emit(EditProfileError());
    }
  }

  FutureOr<void> handleEditProfileWithNameParamsEvent(EditProfile event, Emitter<ProfileState> emit) async {
    emit(EditProfileInfoWithNameLoading());
    try {
      final MutationOptions options = editUser(event.name, null, null, null, null, null, null, null, null, null);
      final QueryResult result = await coreGraphQLService.mutate(options);
      print(result.data.toString());
      if (result.data == null) {
        emit(EditProfileInfoWithNameError());
        return;
      }

      final Map<String, dynamic> data = result.data!;
      final Profile profile = Profile.fromJson(data['editUser']);
      emit(EditProfileInfoWithNameLoaded(profile: profile, userPermissions: null));
    } catch (exception) {
      print(exception.toString());
      emit(EditProfileInfoWithNameError());
    }
  }

  static Future<void> fetchContent(PagingController<int, Content> pagingController, int postType, int limit, int? userId) async {
    print(postType);
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
      print(error.toString());
      pagingController.error = error;
    }
  }

  static Future<void> fetchLikedContent(PagingController<int, Liked> pagingController, int offset, int limit, int? userId) async {
    try {
      final QueryOptions options = getUserFavorites(offset, limit, userId);
      final QueryResult result = await GraphQLService.instance.client.query(options);
      final List<Liked> likedContents = (result.data?['liked'] as List<dynamic>?)
          ?.map((dynamic item) => Liked.fromJson(item as Map<String, dynamic>)).toList() ?? [];
      final isLastPage = likedContents.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(likedContents);
      } else {
        final nextPageKey = pagingController.nextPageKey! + likedContents.length;
        pagingController.appendPage(likedContents, nextPageKey);
      }
    } catch (error) {
      print(error.toString());
      pagingController.error = error;
    }
  }

  static Future<void> fetchComment(PagingController<int, Comment> pagingController, String? postId, int? userId, String type, int offset, int limit) async {
    try {
      await Future.delayed(const Duration(seconds: 4));
      final QueryOptions options = getCommentsWithPostData(postId, userId, type, limit, offset);
      final QueryResult result = await GraphQLService.instance.client.query(options);
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
      pagingController.error = error;
    }
  }


  void navigateToEditProfile(NavigateToEditProfile event, Emitter<ProfileState> emit) {
    print('NavigateToEditProfile');
    emit(NavigationToEditScreenState()); // Emit NavigationState with the route name
  }
}