import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:meta/meta.dart';
import 'package:social_psn/repos/models/media.dart';
import 'package:social_psn/repos/models/post.dart';
import 'package:social_psn/repos/repositories/graphql/post_repository.dart';
import 'package:social_psn/screens/profile/profile_bloc.dart';

import '../../repos/models/admin_setting.dart';
import '../../repos/models/create_media.dart';
import '../../repos/models/create_new_post.dart';
import '../../repos/repositories/dio/dio_profile_repository.dart';
import '../../repos/repositories/graphql/create_post_repository.dart';
import '../../services/graphql_service.dart';
import 'widgets/media_item/media_item.dart';
import 'widgets/media_item/media_item_bloc.dart';

part 'create_post_event.dart';

part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  String? postId;
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final ProfileRepository profileRepository = ProfileRepository();
  AdminSettings? adminSettings;
  String? newPostId;
  Post? newPost;
  List<MediaItem> mediaItems = [];

  CreatePostBloc({this.postId}) : super(CreateMediaInitial()) {
    on<CreateNewPostEvent>(_onCreatePost);
    on<EditPostEvent>(_onEditPost);
    on<ResetCategoryEvent>(_onResetCategory);
    on<SubmitNewPostEvent>(_onSubmitPost);
    on<AddItemEvent>(_onAddItemEvent);
    on<RemoveItemEvent>(_onRemoveItemEvent);
    on<RebuildMediaListEvent>(_onRebuildMediaListEvent);
    postId == null ? add(CreateNewPostEvent()) : add(EditPostEvent());
  }

  // utility functions
  Future<CreateNewPost?> _createNewPost() async {
    try {
      final MutationOptions options = createNewPost();
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        return null;
      } else {
        return CreateNewPost.fromJson(result.data!['createPost']);
      }
    } catch (e) {
      return null;
    }
  }

  Future<AdminSettings?> _fetchLimitations() async {
    try {
      dio.Response result = await profileRepository.getLimitation();
      if (result.data == null) {
        return null;
      }
      return AdminSettings.fromJson(result.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> initializePost(CreateNewPost? createdPost,
      AdminSettings? fetchedSettings, Emitter<CreatePostState> emit) async {
    if (createdPost != null && fetchedSettings != null) {
      newPostId = createdPost.id;
      adminSettings = fetchedSettings;
      await _fetchPostDetails(newPostId!, emit);
    } else {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _fetchPostDetails(
      String postId, Emitter<CreatePostState> emit) async {
    try {
      print(postId);
      final QueryOptions options = postsQuery(id: postId);
      final QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        print(result.hasException.toString());
        emit(PostCreationFailed('خطا در ایجاد پست'));
      } else {
        final Post post = Post.fromJson(result.data!['posts'][0]);
        newPost = post;
        mediaItems = post.medias!
            .map((e) => MediaItem(
                mediaItemBloc: MediaItemBloc(createPostBloc: this),
                createMedia: CreateMedia.network(media: e),
                index: post.medias!.indexOf(e) + 1))
            .toList();
        emit(PostCreationSucceed(post: post, adminSettings: adminSettings!));
      }
    } catch (e) {
      print(e.toString());
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  //event handlers

  Future<void> _onCreatePost(
      CreateNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final results =
          await Future.wait([_createNewPost(), _fetchLimitations()]);
      final CreateNewPost? createdPost = results[0] as CreateNewPost?;
      final AdminSettings? fetchedSettings = results[1] as AdminSettings?;
      await initializePost(createdPost, fetchedSettings, emit);
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onEditPost(
      EditPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final AdminSettings? fetchedSettings = await _fetchLimitations();
      final CreateNewPost? createdPost = CreateNewPost(id: postId);
      await initializePost(createdPost, fetchedSettings, emit);
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onSubmitPost(
      SubmitNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(SubmittingPostLoading());
      bool order = await reOrderMedias();
      if (!order) {
        emit(SubmittingFailed('خطا در ایجاد پست'));
        return;
      }
      final MutationOptions options = SubmitNewPost(
          id: newPostId!,
          title: event.title,
          tag: event.category,
          text: event.longText);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(SubmittingFailed('خطا در ایجاد پست'));
        return;
      } else {
        emit(SubmittingCreateSucceed());
      }
    } catch (e) {
      emit(SubmittingFailed('خطا در ایجاد پست'));
    }
  }

  Future<bool> reOrderMedias() async {
    List<String> newOrder = newPost!.medias!.map((e) => e.id!).toList();
    final MutationOptions options = updateMediaOrder(newOrder, newPost!.id);
    final QueryResult result = await graphQLService.mutate(options);
    if (result.hasException) return false;
    return true;
  }

  void _onResetCategory(
          ResetCategoryEvent event, Emitter<CreatePostState> emit) =>
      emit(ResetCategoryState());

  FutureOr<void> _onRemoveItemEvent(
      RemoveItemEvent event, Emitter<CreatePostState> emit) {
    if (newPost != null) {
      mediaItems.removeWhere(
          (element) => element.createMedia.media!.id == event.mediaId);
      emit(RebuildMediaListState());
    }
  }

  FutureOr<void> _onAddItemEvent(
      AddItemEvent event, Emitter<CreatePostState> emit) {
    if (newPost != null) {
      //newPost!.medias!.add(event.media);
      emit(RebuildMediaListState());
    }
  }

  void _onRebuildMediaListEvent(
          RebuildMediaListEvent event, Emitter<CreatePostState> emit) =>
      emit(RebuildMediaListState());
}
