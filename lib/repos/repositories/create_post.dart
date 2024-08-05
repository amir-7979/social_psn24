import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

QueryOptions getTags({int? limit, int? offset, String? search}) {
  Map<String, dynamic> variables = {};
  if (limit != null) variables['limit'] = limit;
  if (offset != null) variables['offset'] = offset;
  if (search != null) variables['search'] = search;

  return QueryOptions(
    document: gql('''
      query getTags(\$limit: Int, \$offset: Int, \$search: String) {
        tags(limit: \$limit, offset: \$offset, search: \$search) {
          id
          title
          type
          __typename
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

Future<MutationOptions<Object?>> uploadMediaFile(File file, String postId, {int? order}) async {
  Map<String, dynamic> variables = {
    'mediaFile': await multipartFileFrom(file),
    'postId': postId,
  };
  if (order != null) variables['order'] = order;

  return MutationOptions(
    document: gql('''
      mutation uploadMediaFile(\$mediaFile: Upload!, \$postId: String!, \$order: Int) {
        PostMedia(mediaFile: \$mediaFile, post_id: \$postId, order: \$order) {
          id
          loc
          type
          order
        }
      }
    '''),
    variables: variables,
  fetchPolicy: FetchPolicy.noCache,

  );
}

MutationOptions updateMediaOrder(List<String>? mediaIds, String postId) {
  Map<String, dynamic> variables = {
    'media_ids': mediaIds,
    'postId': postId,
  };

  return MutationOptions(
    document: gql('''
      mutation updateMediaOrder(\$media_ids: [String], \$postId: String) {
        PostMediaOrder(media_ids: \$media_ids, post_id: \$postId)
      }
    '''),
    variables: variables,
  );
}

MutationOptions deleteMedia(String mediaId) {
  Map<String, dynamic> variables = {
    'mediaId': mediaId,
  };
  return MutationOptions(
    document: gql('''
      mutation deleteMedia(\$mediaId: String!) {
        DeleteMedia(id: \$mediaId)
      }
    '''),
    variables: variables,
  );
}

Future<MultipartFile> multipartFileFrom(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  String filename = file.path.split('/').last;
  String? mimeType = lookupMimeType(file.path);
  final multipartFile = http.MultipartFile.fromBytes(
    '1', // field name
    fileBytes, // file bytes
    filename: filename, // file name
    contentType: MediaType.parse(mimeType!), // content type
  );
  return multipartFile;
}

MutationOptions createNewPost() {
  return MutationOptions(
    document: gql('''
        mutation createPost {
          createPost() {
            id,
          }
        }
      '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

