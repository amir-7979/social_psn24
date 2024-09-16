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
  }

  Future<void> _onUploadMediaItem(UploadMediaItemEvent event, Emitter<MediaItemState> emit) async {
    emit(MediaItemUploading(event.mediaFile));
    try {
      // Replace with actual upload logic
      final MutationOptions options = await uploadMediaFile(event.mediaFile, createPostBloc.NewPost!.id!);
      final QueryResult result = await graphQLService.mutate(options);

      if (result.hasException) {
        emit(MediaItemUploadFailed('Error uploading media'));
      } else {
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
}