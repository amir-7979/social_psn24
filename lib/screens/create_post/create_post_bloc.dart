import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:social_psn/repos/models/media.dart';
import 'package:social_psn/repos/models/post.dart';
import 'package:social_psn/repos/repositories/graphql/post_repository.dart';

import '../../repos/models/create_new_post.dart';
import '../../repos/repositories/graphql/create_post_repository.dart';
import '../../services/graphql_service.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final GraphQLClient graphQLService = GraphQLService.instance.client;
  CreateNewPost? NewPost = CreateNewPost();

  CreatePostBloc() : super(CreateMediaInitial()) {
    // Register event handlers
    on<UploadMediaEvent>(_onUploadMedia);
    on<DeleteMediaEvent>(_onDeleteMedia);
    on<ChangeMediaOrderEvent>(_onChangeMediaOrder);
    on<CreateNewPostEvent>(_onCreatePost);
    on<ResetCategoryEvent>(_onResetCategory);
    add(CreateNewPostEvent());
  }

  Future<void> _onUploadMedia(UploadMediaEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(MediaUploading(event.mediaFile));
      final MutationOptions options = await uploadMediaFile(event.mediaFile, NewPost!.id!);
      final QueryResult result = await graphQLService.mutate(options);
        if (result.hasException) {
          emit(MediaUploadFailed('خطا در آپلود محتوا'));
        } else {
          Media media = Media.fromJson(result.data!['PostMedia']);
          emit(MediaUploaded(media));
        }
    } catch (e) {
      emit(MediaUploadFailed('خطا در آپلود محتوا'));
    }
  }

  Future<void> _onDeleteMedia(DeleteMediaEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(MediaDeleting(event.mediaId));
      final MutationOptions options = deleteMedia(event.mediaId);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(MediaDeleteFailed('خطا در حذف محتوا'));
      }else{
        emit(MediaDeleted(event.mediaId));
      }
    } catch (e) {
      emit(MediaDeleteFailed('خطا در حذف محتوا'));
    }
  }

  Future<void> _onChangeMediaOrder(ChangeMediaOrderEvent event, Emitter<CreatePostState> emit) async {
    try {
      // Simulate changing media order
      await Future.delayed(Duration(seconds: 1));
      emit(MediaOrderChanged());
    } catch (e) {
      //emit(CreateMediaError('Failed to change media order'));
    }
  }

  Future<void> _onCreatePost(CreateNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(CreatingNewPost());
      final MutationOptions options = createNewPost();
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(PostCreationFailed('خطا در ایجاد پست'));
        return;
      }else {
        NewPost = CreateNewPost.fromJson(result.data!['createPost']);
        final QueryOptions options = postsQuery(id: NewPost!.id!);
        final QueryResult result2 = await graphQLService.query(options);
        if (result2.hasException) {
          emit(PostCreationFailed('خطا در ایجاد پست'));
          return;
      }else{
          final Post post = Post.fromJson(result2.data!['posts'][0]);
         emit(PostCreationSucceed(post));
        }
      }
    } catch (e) {
      emit(PostCreationFailed('خطا در ایجاد پست'));
    }
  }

  Future<void> _onSubmitPost(CreateNewPostEvent event, Emitter<CreatePostState> emit) async {
    try {
      emit(SubmittingPostLoading());
      final MutationOptions options = createNewPost();
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(SubmittingCreateFailed('خطا در ایجاد پست'));
        return;
      }else {
        NewPost = CreateNewPost.fromJson(result.data!['createPost']);
        emit(SubmittingCreateSucceed());
      }
    } catch (e) {
      emit(SubmittingCreateFailed('خطا در ایجاد پست'));
    }
  }

  FutureOr<void> _onResetCategory(ResetCategoryEvent event, Emitter<CreatePostState> emit) {
    emit(ResetCategoryState());
  }
}