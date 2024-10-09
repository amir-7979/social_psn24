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
import '../../repos/models/create_new_post.dart';
import '../../repos/repositories/dio/dio_profile_repository.dart';
import '../../repos/repositories/graphql/create_post_repository.dart';
import '../../services/graphql_service.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  String? postId;
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  final ProfileRepository profileRepository = ProfileRepository();
  AdminSettings? adminSettings;
  String? newPostId;
  Post? newPost;

  CreatePostBloc({this.postId}) : super(CreateMediaInitial()) {
    on<ChangeMediaOrderEvent>(_onChangeMediaOrder);
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

  Future<void> initializePost(CreateNewPost? createdPost, AdminSettings? fetchedSettings, Emitter<CreatePostState> emit) async {
    if (createdPost != null && fetchedSettings != null) {
      newPostId = createdPost.id;
      adminSettings = fetchedSettings;
      await _fetchPostDetails(newPostId!, emit);
    } else {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _fetchPostDetails(String postId, Emitter<CreatePostState> emit) async {
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
        emit(PostCreationSucceed(post: post, adminSettings: adminSettings!));
      }
    } catch (e) {
      print(e.toString());
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  //event handlers

  Future<void> _onCreatePost(CreateNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final results = await Future.wait([_createNewPost(), _fetchLimitations()]);
      final CreateNewPost? createdPost = results[0] as CreateNewPost?;
      final AdminSettings? fetchedSettings = results[1] as AdminSettings?;
      await initializePost(createdPost, fetchedSettings, emit);
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onEditPost(EditPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final AdminSettings? fetchedSettings = await _fetchLimitations();
      final CreateNewPost? createdPost = CreateNewPost(id: postId);
      await initializePost(createdPost, fetchedSettings, emit);
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onSubmitPost(SubmitNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(SubmittingPostLoading());
      final MutationOptions options = SubmitNewPost(id: newPostId!, title: event.title, tag: event.category, text: event.longText);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(SubmittingFailed('خطا در ایجاد پست'));
        return;
      }else {
        emit(SubmittingCreateSucceed());
      }
    } catch (e) {
      emit(SubmittingFailed('خطا در ایجاد پست'));
    }
  }

  void _onResetCategory(ResetCategoryEvent event, Emitter<CreatePostState> emit) => emit(ResetCategoryState());

  Future<void> _onChangeMediaOrder(ChangeMediaOrderEvent event, Emitter<CreatePostState> emit) async {
    final copeMedias = newPost!.medias!;
    try {
      final item = newPost!.medias!.removeAt(event.oldIndex);
      newPost!.medias!.insert(event.newIndex, item);
      List<String> newOrder = newPost!.medias!.map((e) => e.id!).toList();
      final MutationOptions options = updateMediaOrder(newOrder, newPost!.id);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(MediaOrderChangeFailed('خطا در تغییر ترتیب محتوا'));
        newPost!.medias = copeMedias;
        return;
      }
      emit(MediaOrderChanged());
    } catch (e) {
      emit(MediaOrderChangeFailed('خطا در تغییر ترتیب محتوا'));
      newPost!.medias = copeMedias;
      return;
    }
  }

  FutureOr<void> _onRemoveItemEvent(RemoveItemEvent event, Emitter<CreatePostState> emit) {
    if (newPost != null) {
      print('remove item');
      newPost!.medias!.removeWhere((element) => element.id == event.mediaId);
      emit(RebuildMediaListState());
    }
  }

  FutureOr<void> _onAddItemEvent(AddItemEvent event, Emitter<CreatePostState> emit) {
    if (newPost != null) {
      newPost!.medias!.add(event.media);
      emit(RebuildMediaListState());
    }
  }

  void _onRebuildMediaListEvent(RebuildMediaListEvent event, Emitter<CreatePostState> emit) => emit(RebuildMediaListState());
}