import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

QueryOptions postsQuery({String? id, int? isPublish, String? tagId, String? search, int? limit, int? offset, int? postType}) {
  Map<String, dynamic> variables = {};
  if (id != null) variables['id'] = id;
  if (isPublish != null) variables['isPublish'] = isPublish;
  if (tagId != null) variables['tagId'] = tagId;
  if (search != null) variables['search'] = search;
  if (limit != null) variables['limit'] = limit;
  if (offset != null) variables['offset'] = offset;
  if (postType != null) variables['postType'] = postType;

  return QueryOptions(
    document: gql('''
        query postsQuery(\$id: String, \$isPublish: Int, \$tagId: String, \$search: String, \$limit: Int, \$offset: Int, \$postType: Int) {
          posts(id: \$id, is_publish: \$isPublish, tag_id: \$tagId, search: \$search, limit: \$limit, offset: \$offset, post_type: \$postType) {
            id, tag_id, name, description, created_at, current_user_liked, current_user_up_votes, current_user_down_votes, current_user_notification_enabled, post_type, is_publish,
            comments_count, down_votes, up_votes, view_count, medias {
              id, loc, type, thumbnails {
                id, loc, type
              }
            }, creator {
              id,global_id, name, family, username, photo, online, display_name, show_activity
            }
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions topUsers() {
  return QueryOptions(
    document: gql('''
        query topUsers {
          topPostCreators {
            name, family, photo, postscount, id
          }
        }
      '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions topPosts() {
  return QueryOptions(
    document: gql('''
        query topPosts {
          topPosts {
            id, name, created_at, comments_count, medias {
              loc, type, thumbnails {
                loc, type
              }
            }
          }
        }
      '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions getComments({String? postId, String? type, int? userId, int? limit, int? offset}) {
  Map<String, dynamic> variables = {};
  if (postId != null) variables['postId'] = postId;
  if (type != null) variables['type'] = type;
  if (userId != null) variables['userId'] = userId;
  if (limit != null) variables['limit'] = limit;
  if (offset != null) variables['offset'] = offset;

  return QueryOptions(
    document: gql('''
        query getComments(\$postId: String, \$type: String, \$userId: Float, \$limit: Int, \$offset: Int) {
          comments(post_id: \$postId, type: \$type, user_id: \$userId, limit: \$limit, offset: \$offset) {
            id, message, created_at, reply_to,
            replies {
              id, message, created_at, reply_to, sender_id {
                id, global_id, name, family, photo, username,
              }
            }
            sender_id {
              id, global_id, name, family, photo, username,
            }
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions getCommentsWithPostData({String? postId, String? type, int? userId, int? limit, int? offset}) {
  Map<String, dynamic> variables = {};
  if (postId != null) variables['postId'] = postId;
  if (type != null) variables['type'] = type;
  if (userId != null) variables['userId'] = userId;
  if (limit != null) variables['limit'] = limit;
  if (offset != null) variables['offset'] = offset;

  return QueryOptions(
    document: gql('''
        query getCommentsWithPostData(\$postId: String, \$type: String, \$userId: Float, \$limit: Int, \$offset: Int) {
          comments(post_id: \$postId, type: \$type, user_id: \$userId, limit: \$limit, offset: \$offset) {
            id, message, created_at, reply_to,
            replies {
              id, message,
            }
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
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions editPost({String? id, String? title, String? text, int? tag, int? status, int? postType, int? isPublish}) {
  Map<String, dynamic> variables = {};
  if (id != null) variables['id'] = id;
  if (title != null) variables['title'] = title;
  if (text != null) variables['text'] = text;
  if (tag != null) variables['tag'] = tag;
  if (status != null) variables['status'] = status;
  if (postType != null) variables['postType'] = postType;
  if (isPublish != null) variables['isPublish'] = isPublish;

  return MutationOptions(
    document: gql('''
        mutation editPost(\$id: String!, \$title: String!, \$text: String!, \$tag: Int!, \$status: Int!, \$postType: Int!, \$isPublish: Int!) {
          editPost(id: \$id, name: \$title, description: \$text, post_type: \$postType,tag_id:\$tag, status: \$status, is_publish: \$isPublish) {
            id, name, description, user_id
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions increasePostView({String? id, int? status, int? viewCount}) {
  Map<String, dynamic> variables = {};
  if (id != null) variables['id'] = id;
  if (status != null) variables['status'] = status;
  if (viewCount != null) variables['viewCount'] = viewCount;

  return MutationOptions(
    document: gql('''
        mutation increasePostView(\$id: String!, \$status: Int!, \$viewCount: Int!) {
          editPost(id: \$id, status: \$status, view_count: \$viewCount) {
            view_count
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions likePost(String postId) {
  return MutationOptions(
    document: gql('''
        mutation likePost(\$postId: String!) {
          createLike(post_id: \$postId) {
            id
          }
        }
      '''),
    variables: {'postId': postId},
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions enableUserNotification(int userId) {
  return MutationOptions(
    document: gql('''
        mutation enableNotification(\$userId: Float!) {
          createEnNotification(user_id: \$userId) {
            id
          }
        }
      '''),
    variables: {'userId': userId},
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions enableNotification(String postId) {
  return MutationOptions(
    document: gql('''
        mutation enableNotification(\$postId: String!) {
          createEnNotification(post_id: \$postId) {
            id
          }
        }
      '''),
    variables: {'postId': postId},
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions votePost({String? postId, String? type}) {
  Map<String, dynamic> variables = {};
  if (postId != null) variables['postId'] = postId;
  if (type != null) variables['type'] = type;

  return MutationOptions(
    document: gql('''
        mutation votePost(\$postId: String!, \$type: String!) {
          createVote(post_id: \$postId, type: \$type) {
            id
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions createComment({required String postId, required String message, String? replyTo}) {
  Map<String, dynamic> variables = {};
  variables['postId'] = postId;
  variables['message'] = message;
  if (replyTo != null) variables['replyTo'] = replyTo;

  return MutationOptions(
    document: gql('''
        mutation createComment(\$postId: String!, \$message: String!, \$replyTo: String) {
          createComment(post_id: \$postId, message: \$message, reply_to: \$replyTo) {
            id
          }
        }
      '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
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
    fetchPolicy: FetchPolicy.noCache,
  );
}

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
    fetchPolicy: FetchPolicy.cacheAndNetwork,
  );
}

QueryOptions searchUser({String? search, }) {
  Map<String, dynamic> variables = {};
  if (search != null) variables['search'] = search;

  return QueryOptions(
    document: gql('''
      query searchUser(\$search: String) {
          currentUser(search: \$search) {
            name
            family
            username
            id
            photo
            __typename
          }
        }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.cacheAndNetwork,
  );
}

//

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
      query getUserProfile(\$id: Float) {
        profile(id: \$id) {
          id, name, family, display_name, username, photo, phone, commentsCreated, contentCreated, upvotes, downvotes, field, biography, experience,
          address, offices, online, allow_notification, current_user_notification_enabled, last_activity
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
      query getUserPosts(\$postType: Int, \$limit: Int, \$offset: Int, \$userId: Float) {
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

QueryOptions getUserActivities(int id) {
  return QueryOptions(
    document: gql('''
      query getUserActivities(\$id: Float) {
        profile(id: \$id) {
          commentsCreated
          contentCreated
          upvotes
          downvotes
        }
      }
    '''),
    variables: {'id': id},
    fetchPolicy: FetchPolicy.noCache,
  );
}