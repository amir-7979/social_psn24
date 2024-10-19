import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:meta/meta.dart';
import 'package:mime/mime.dart';
import '../../../../repos/models/media.dart';
import '../../../../repos/repositories/graphql/create_post_repository.dart';
import '../../../../services/graphql_service.dart';
import '../../create_post_bloc.dart';
part 'media_item_event.dart';
part 'media_item_state.dart';

class MediaItemBloc extends Bloc<MediaItemEvent, MediaItemState> {
  final CreatePostBloc createPostBloc;
  final graphql.GraphQLClient graphQLService = GraphQLService.instance.client;
  final CancelToken cancelToken = CancelToken();
  MediaItemBloc({required this.createPostBloc}) : super(MediaItemInitial()) {
    on<UploadMediaItemEvent>(_onUploadMediaItem);
    on<DeleteMediaEvent>(_onDeleteMedia);
  }

  Future<dio.MultipartFile> multipartFileFrom(File file) async {
    List<int> fileBytes = await file.readAsBytes();
    String filename = file.path.split('/').last;
    String? mimeType = lookupMimeType(file.path);
    final multipartFile = dio.MultipartFile.fromBytes(
        fileBytes,
      filename: filename, // file name
      contentType: http_parser.MediaType.parse(mimeType!), // content type
    );
    return multipartFile;
  }


  Future<void> _onUploadMediaItem(UploadMediaItemEvent event, Emitter<MediaItemState> emit) async {
    emit(MediaItemUploading(event.mediaFile!));
    emit(MediaUploadProgress(progress: 0, message: '0/0'));
    try {
      final String postId = createPostBloc.newPost!.id;
      final int order = createPostBloc.newPost!.medias!.length + 1;
      final MultipartFile file = await multipartFileFrom(event.mediaFile!);
      final String mutation = '''
    mutation uploadMediaFile(\$mediaFile: Upload!, \$postId: String!, \$order: Int) {
      PostMedia(mediaFile: \$mediaFile, post_id: \$postId, order: \$order) {
        id
        loc
        type
        order
      }
    }
    ''';
      final Map<String, dynamic> variables = {
        'mediaFile': null,
        'postId': postId,
        'order': order,
      };
      final Map<String, dynamic> operations = {
        'query': mutation,
        'variables': variables,
      };
      final Map<String, List<String>> map = {
        '0': ['variables.mediaFile'],
      };
      final dio.FormData formData = dio.FormData.fromMap({
        'operations': json.encode(operations),
        'map': json.encode(map),
        '0': file,
      });
      final response = await GraphQLService.instance.dio.post(
        'https://api.psn24.ir/graphql',
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: (int sent, int total) {
          final double progress = sent / total;
          double totalInMb = total / (1024 * 1024);
          double sentInMb = sent / (1024 * 1024);
          double formattedTotalInMb = double.parse(totalInMb.toStringAsFixed(2));
          double formattedSentInMb = double.parse(sentInMb.toStringAsFixed(2));
          emit(MediaUploadProgress(
            progress: progress, // Keep the raw progress value for the UI
            message: '${formattedSentInMb}MB / ${formattedTotalInMb}MB',
          ));
        },

      );
      if (response.statusCode == 200) {
        final mediaData = response.data['data']['PostMedia'];
        print(mediaData);
        final Media media = Media.fromJson(mediaData);
        emit(MediaItemUploaded(media));
      } else {
        createPostBloc.mediaItems.removeWhere((element) => element.createMedia.file == event.mediaFile);
        createPostBloc.add(RebuildMediaListEvent());
        emit(MediaItemUploadFailed('خطا در آپلود محتوا'));
      }
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        emit(MediaItemUploadCancelled());
      } else {
        print(e.toString());
        emit(MediaItemUploadFailed('خطا در آپلود محتوا'));
      }
      createPostBloc.mediaItems.removeWhere((element) => element.createMedia.file == event.mediaFile);
      createPostBloc.add(RebuildMediaListEvent());
    }
  }

/*
  Future<MultipartFile> _createMultipartFile(File file) async {
    final fileBytes = await file.readAsBytes();
    final filename = file.path.split('/').last;
    final mimeType = lookupMimeType(file.path);

    return MultipartFile.fromBytes(
      fileBytes, // List<int> of file bytes
      filename: filename, // File name
      contentType: mimeType != null ? http_parser.MediaType.parse(mimeType) : null, // Content type
    );
  }
*/

  Future<void> _onDeleteMedia(DeleteMediaEvent event, Emitter<MediaItemState> emit) async {
    emit(MediaDeleting(event.mediaId));
    try {
      final graphql.MutationOptions options = deleteMedia(event.mediaId);
      final graphql.QueryResult result = await graphQLService.mutate(options);

      if (result.hasException) {
        emit(MediaDeleteFailed('خطا در حذف محتوا'));
      } else {
        final bool deleteSuccess = result.data?['DeleteMedia'] ?? false;
        if (deleteSuccess) {
          emit(MediaDeleted(event.mediaId));
          createPostBloc.add(RemoveItemEvent(event.mediaId));
        } else {
          emit(MediaDeleteFailed('خطا در حذف محتوا'));
        }
      }
    } catch (e) {
      emit(MediaDeleteFailed('خطا در حذف محتوا'));
    }
  }
}
