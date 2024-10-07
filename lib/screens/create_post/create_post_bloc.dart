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
  CreateNewPost? NewPost;

  CreatePostBloc({this.postId}) : super(CreateMediaInitial()) {
    on<ChangeMediaOrderEvent>(_onChangeMediaOrder);
    on<CreateNewPostEvent>(_onCreatePost);
    on<EditPostEvent>(_onEditPost);
    on<ResetCategoryEvent>(_onResetCategory);
    on<SubmitNewPostEvent>(_onSubmitPost);
    on<GetMediasEvent>(_onGetMedias);
    postId == null ? add(CreateNewPostEvent()) : add(EditPostEvent());
  }

  //post section
  Future<void> _onCreatePost(CreateNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final results = await Future.wait([_createNewPost(), _fetchLimitations()]);
      final CreateNewPost? createdPost = results[0] as CreateNewPost?;
      final AdminSettings? fetchedSettings = results[1] as AdminSettings?;
      if (createdPost != null && fetchedSettings != null) {
        NewPost = createdPost;
        adminSettings = fetchedSettings;
        await _fetchPostDetails(NewPost!.id!, emit);
      } else {
        emit(PostCreationFailed('خطا در ایجاد پست'));
      }
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onEditPost(EditPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final AdminSettings? fetchedSettings = await _fetchLimitations();
      final CreateNewPost? createdPost = CreateNewPost(id: postId);
      if (createdPost != null && fetchedSettings != null) {
        NewPost = createdPost;
        adminSettings = fetchedSettings;
        await _fetchPostDetails(NewPost!.id!, emit);
      } else {
        emit(PostCreationFailed('خطا در ایجاد پست'));
      }
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

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

  Future<void> _fetchPostDetails(String postId, Emitter<CreatePostState> emit) async {
    try {
      final QueryOptions options = postsQuery(id: postId);
      final QueryResult result = await graphQLService.query(options);
      if (result.hasException) {
        print(result.hasException.toString());
        emit(PostCreationFailed('خطا در ایجاد پست'));
      } else {
        final Post post = Post.fromJson(result.data!['posts'][0]);
        emit(PostCreationSucceed(post: post, adminSettings: adminSettings!));
      }
    } catch (e) {
      print(e.toString());
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onSubmitPost(SubmitNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(SubmittingPostLoading());
      final MutationOptions options = SubmitNewPost(id: NewPost!.id!, title: event.title, tag: event.category, text: event.longText);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(SubmittingCreateFailed('خطا در ایجاد پست'));
        return;
      }else {
        emit(SubmittingCreateSucceed());
      }
    } catch (e) {
      emit(SubmittingCreateFailed('خطا در ایجاد پست'));
    }
  }

  FutureOr<void> _onResetCategory(ResetCategoryEvent event, Emitter<CreatePostState> emit) {
    emit(ResetCategoryState());
  }


  Future<void> _onChangeMediaOrder(ChangeMediaOrderEvent event, Emitter<CreatePostState> emit) async {
    try {
      final MutationOptions options = updateMediaOrder(event.newOrder, event.postId,);
      final QueryResult result = await graphQLService.mutate(options);
      print(result.data);
      emit(MediaOrderChanged());
    } catch (e) {
      emit(MediaOrderChanged());
    }
  }

  FutureOr<void> _onGetMedias(GetMediasEvent event, Emitter<CreatePostState> emit) {
  }
}