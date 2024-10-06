import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';

import '../../../../repos/models/media.dart';
import '../../../../repos/repositories/graphql/create_post_repository.dart';
import '../../../../services/graphql_service.dart';
import '../../create_post_bloc.dart';

part 'media_item_event.dart';
part 'media_item_state.dart';

class MediaItemBloc extends Bloc<MediaItemEvent, MediaItemState> {
  final CreatePostBloc createPostBloc;
  final GraphQLClient graphQLService = GraphQLService.instance.client;

  MediaItemBloc({required this.createPostBloc}) : super(MediaItemInitial()) {
    on<UploadMediaItemEvent>(_onUploadMediaItem);
    on<CancelUploadMediaItemEvent>(_onCancelUploadMediaItem);
    on<DeleteMediaEvent>(_onDeleteMedia);
  }

  Future<void> _onUploadMediaItem(UploadMediaItemEvent event, Emitter<MediaItemState> emit) async {
    emit(MediaItemUploading(event.mediaFile!));
    print('Uploading media');
    try {
      final MutationOptions options = await uploadMediaFile(event.mediaFile!, createPostBloc.NewPost!.id!);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(MediaItemUploadFailed('Error uploading media'));
      } else {
        print(result.data.toString());
        Media media = Media.fromJson(result.data!['PostMedia']);
        emit(MediaItemUploaded(media));
      }
    } catch (e) {
      emit(MediaItemUploadFailed('Error uploading media'));
    }
  }

  Future<void> _onCancelUploadMediaItem(CancelUploadMediaItemEvent event, Emitter<MediaItemState> emit) async {
    // Add cancellation logic
    emit(MediaItemInitial());
  }

  Future<void> _onDeleteMedia(DeleteMediaEvent event, Emitter<MediaItemState> emit) async {
    try {
      emit(MediaDeleting(event.mediaId));
      final MutationOptions options = deleteMedia(event.mediaId);
      final QueryResult result = await graphQLService.mutate(options);
      if (result.hasException) {
        emit(MediaDeleteFailed('خطا در حذف محتوا'));
      }else{
        print(result.data.toString());
        emit(MediaDeleted(event.mediaId));
        createPostBloc.add(GetMediasEvent());
      }
    } catch (e) {
      emit(MediaDeleteFailed('خطا در حذف محتوا'));
    }
  }

}