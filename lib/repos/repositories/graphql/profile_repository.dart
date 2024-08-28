import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
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
        adminSettings {
          max_size_for_media_mb
          max_size_for_pic_MB
          max_size_for_pic_PrivateMB
          max_size_for_video_MB
          max_size_for_video_PrivateMB
          max_size_for_voice_MB
          max_size_for_voice_PrivateMB
          max_time_for_video_PrivateSec
          max_time_for_video_Sec
          max_time_for_voice_PrivateSec
          max_time_for_voice_Sec
          allowed_formats_for_Pic
          allowed_formats_for_Video
          allowed_formats_for_Voice
          allowed_formats_for_PrivatePic
          allowed_formats_for_PrivateVideo
          allowed_formats_for_PrivateVoice
          max_count_for_pic_PrivateSlide
          max_count_for_pic_Slide
          max_count_for_text_PrivateSlide
          max_count_for_text_Slide
          max_count_for_video_PrivateSlide
          max_count_for_video_Slide
          max_count_for_voice_PrivateSlide
          max_count_for_voice_Slide
          max_characters_for_pic_Post
          max_characters_for_pic_PrivatePost
          max_characters_for_post
          max_characters_for_text_Post
          max_characters_for_video_Post
          max_characters_for_video_PrivatePost
          max_characters_for_voice_Post
          max_characters_for_voice_PrivatePost
          max_characters_for_comment
          max_session_count
          resend_sms_time_sec
          time_to_set_offline_sec
          token_expire_time_sec
          draft_storage_max_time_sec
          failed_login_max_count
          id
          is_active
          __typename
        }
        profile {
          id, name, family, display_name, photo, phone, username
        }
        
      }
    '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions getUserPermissions() {

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
       adminSettings {
          max_size_for_media_mb
          max_size_for_pic_MB
          max_size_for_pic_PrivateMB
          max_size_for_video_MB
          max_size_for_video_PrivateMB
          max_size_for_voice_MB
          max_size_for_voice_PrivateMB
          max_time_for_video_PrivateSec
          max_time_for_video_Sec
          max_time_for_voice_PrivateSec
          max_time_for_voice_Sec
          allowed_formats_for_Pic
          allowed_formats_for_Video
          allowed_formats_for_Voice
          allowed_formats_for_PrivatePic
          allowed_formats_for_PrivateVideo
          allowed_formats_for_PrivateVoice
          max_count_for_pic_PrivateSlide
          max_count_for_pic_Slide
          max_count_for_text_PrivateSlide
          max_count_for_text_Slide
          max_count_for_video_PrivateSlide
          max_count_for_video_Slide
          max_count_for_voice_PrivateSlide
          max_count_for_voice_Slide
          max_characters_for_pic_Post
          max_characters_for_pic_PrivatePost
          max_characters_for_post
          max_characters_for_text_Post
          max_characters_for_video_Post
          max_characters_for_video_PrivatePost
          max_characters_for_voice_Post
          max_characters_for_voice_PrivatePost
          max_characters_for_comment
          max_session_count
          resend_sms_time_sec
          time_to_set_offline_sec
          token_expire_time_sec
          draft_storage_max_time_sec
          failed_login_max_count
          id
          is_active
          __typename
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


MutationOptions enableNotification(int userId) {
  return MutationOptions(
    document: gql('''
      mutation enableNotification(\$userId: Int!) {
        createEnNotification(user_id: \$userId) {
          id
          __typename
        }
      }
    '''),
    variables: {'userId': userId},
    fetchPolicy: FetchPolicy.noCache, // Retain this line if you want to avoid caching
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

MutationOptions cooperate(String name, String phone) {
  return MutationOptions(
    document: gql('''
      mutation cooperate(\$name: String, \$phone: String) {
        ContactUs(name: \$name, email: \$phone) {
          name,
          email,
        }
      }
    '''),
    variables: {'name': name, 'phone': phone},
    fetchPolicy: FetchPolicy.noCache,
  );
}

