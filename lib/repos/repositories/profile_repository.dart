import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:async/async.dart';
import 'package:mime/mime.dart';

QueryOptions getUserProfileWithPermissions() {

  return QueryOptions(
    document: gql('''
      query {
        userPermissions{
          id, name, display_name, permissions{
            id, name,
          }
          role, settings{
            id, options
          }
        }
        profile {
          id, name, family, display_name, photo, phone
        }
      }
    '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions getUserProfile(int? id) {
  Map<String, dynamic> variables = {};
  if (id != null) variables['id'] = id;

  return QueryOptions(
    document: gql('''
      query getUserProfile(\$id: Int) {
        profile(id: \$id) {
          id, name, family, display_name, username, photo, phone, commentsCreated, contentCreated, upvotes, downvotes, field, biography, experience,
          address, offices, online, allow_notification, current_user_notification_enabled, show_activity
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,

  );
}

QueryOptions getUserPosts(int postType, int limit, int offset, int? userId) {
  Map<String, dynamic> variables = {
    'postType': postType,
    'limit': limit,
    'offset': offset,
  };
  if (userId != null) variables['userId'] = userId;

  return QueryOptions(
    document: gql('''
      query getUserPosts(\$postType: Int, \$limit: Int, \$offset: Int, \$userId: Int) {
        mycontents(post_type: \$postType, limit: \$limit, offset: \$offset, user_id: \$userId) {
          id, name, post_type, disable, medias {
            id, loc, type, thumbnails {
              loc, type
            }
          }
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

QueryOptions getCommentsWithPostData(
    String? postId, int? userId, String type, int limit, int offset) {
  Map<String, dynamic> variables = {};
  if (postId != null) variables['postId'] = postId;
  if (userId != null) variables['userId'] = userId;
  variables['type'] = type;
  variables['limit'] = limit;
  variables['offset'] = offset;

  return QueryOptions(
    document: gql('''
      query getCommentsWithPostData(\$postId: String, \$type: String, \$userId: Int, \$limit: Int, \$offset: Int) {
        comments(post_id: \$postId, type: \$type, user_id: \$userId, limit: \$limit, offset: \$offset) {
          id, message, created_at, reply_to,
          replies {
            id, message
          },
          post_id {
            id, name,
            medias {
              id, loc, type, thumbnails {
                loc, type
              }
            },
          }
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

QueryOptions getUserFavorites(int offset, int limit, int? userId) {
  Map<String, dynamic> variables = {
    'offset': offset,
    'limit': limit,
  };
  if (userId != null) variables['userId'] = userId;

  return QueryOptions(
    document: gql('''
      query getUserFavorites(\$offset: Int, \$limit: Int, \$userId: Int) {
        liked(offset: \$offset , limit: \$limit, user_id: \$userId) {
          id, name, medias {
            id, owner_id, post_id, loc, type, thumbnails {
              loc, type
            }
          }
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions editUser(
    String? name,
    String? family,
    String? username,
    String? photo,
    String? biography,
    String? experience,
    ) {
  Map<String, dynamic> variables = {};

  if (name != null) variables['name'] = name;
  if (family != null) variables['family'] = family;
  if (username != null) variables['username'] = username;
  if (photo != null) variables['photo'] = photo;
  if (biography != null) variables['biography'] = biography;
  if (experience != null) variables['experience'] = experience;

  return MutationOptions(
    document: gql('''
      mutation editUser(\$name: String, \$family: String, \$photo: String, \$biography: String, \$field: String, \$experience: String, \$address: String, \$office: [String],\$showActivity: Int, \$username: String) {
        editUser(name: \$name, family: \$family, photo: \$photo, biography: \$biography, field: \$field, experience: \$experience, address: \$address, office: \$office, allow_notification: 1, show_activity: \$showActivity, username: \$username) {
          id
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions deleteAccount(String name) {
  return MutationOptions(
    document: gql('''
      mutation deleteAccount(\$name: String) {
        editUser(name: \$name, delete: 1) {
          id
        }
      }
    '''),
    variables: {'name': name},
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions toggleAllowNotification(
    String name, String family, int notification) {
  return MutationOptions(
    document: gql('''
      mutation toggleAllowNotification(\$name: String!, \$family: String!, \$notification: Int!) {
        editUser(name: \$name, family: \$family, allow_notification: \$notification) {
          allow_notification
        }
      }
    '''),
    variables: {'name': name, 'family': family, 'notification': notification},
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions changeOnlineStatus() {
  return MutationOptions(
    document: gql('''
      mutation changeOnlineStatus {
        ChangeOnlineStatus{
          name,
          status
        }
      }
    '''),
    variables: {},
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

Future<MutationOptions<Object>> uploadProfileImage(File file) async {
  return MutationOptions(
    document: gql('''
      mutation uploadProfileImage(\$file: Upload) {
        uploadProfileImage(profilePicture: \$file)
      }
    '''),
    variables: {
      'file': await multipartFileFrom(file),
    },
    fetchPolicy: FetchPolicy.noCache,
  );
}

Future<MultipartFile> multipartFileFrom(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  String filename = file.path.split('/').last;
  String? mimeType = lookupMimeType(file.path);

  final multipartFile = http.MultipartFile.fromBytes(
    'profilePicture', // field name
    fileBytes, // file bytes
    filename: filename, // file name
    contentType: MediaType.parse(mimeType!), // content type
  );
  return multipartFile;
}

MutationOptions enableNotification(int userId) {
  return MutationOptions(
    document: gql('''
      mutation enableNotification(\$userId: Int) {
        createEnNotification(user_id: \$userId) {
          id
        }
      }
    '''),
    variables: {'userId': userId},
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions deletePost(String id) {
  return MutationOptions(
    document: gql('''
        mutation deletePost(\$id: String!) {
          deletePost(id: \$id)
        }
      '''),
    variables: {'id': id},
    fetchPolicy: FetchPolicy.noCache, // Add this line
  );
}

MutationOptions fetchUserPermissionsMutation() {
  return MutationOptions(
    document: gql('''
      mutation {
        userPermissions {
          id, name, display_name,
          permissions {
            id, name,
          }
          role,
          settings {
            id, options
          }
        }
      }
    '''),
    fetchPolicy: FetchPolicy.noCache,

  );

}
