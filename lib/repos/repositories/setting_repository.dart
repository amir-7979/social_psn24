import 'package:graphql_flutter/graphql_flutter.dart';


QueryOptions userPermissions(int id) {
  return QueryOptions(
    document: gql('''
      query userPermissions(\$id: Int) {
        userPermissions(id: \$id) {
          allow_notification
          permissions {
            id, name
          },
          settings {
            id, options
          }
        }
      }
    '''),
    variables: {'id': id},
    fetchPolicy: FetchPolicy.noCache,
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

QueryOptions userPermissionsPermission(int id) {
  return QueryOptions(
    document: gql('''
      query userPermissions_permission(\$id: Int) {
        userPermissions(id: \$id) {
          permissions {
            name
          },
        }
      }
    '''),
    variables: {'id': id},
    fetchPolicy: FetchPolicy.noCache,
  );
}

MutationOptions setNotificationToken(String token) {
  return MutationOptions(
    document: gql('''
      mutation setNotificationToken(\$token: String) {
        SetFCMToken(fcm_token: \$token)
      }
    '''),
    variables: {'token': token},
    fetchPolicy: FetchPolicy.noCache,
  );
}

QueryOptions getNotifications(String? contentId, bool? seen, int? targetId) {
  Map<String, dynamic> variables = {};
  if (contentId != null) {
    variables['contentId'] = contentId;
  }
  if (seen != null) {
    variables['seen'] = seen;
  }
  if (targetId != null) {
    variables['targetId'] = targetId;
  }

  return QueryOptions(
    document: gql('''
      query notifications(\$contentId: String, \$seen: Boolean, \$targetId: Int) {
        notifications(content_id: \$contentId, seen: \$seen, target_id: \$targetId) {
          created_at, id, message, seen, type, target_id {
            name, family, photo, id
          }, content_id {
            name, id, medias {
              loc, thumbnails {
                loc
              }
            }
          }
        }
      }
    '''),
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
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

QueryOptions adminSettings() {
  Map<String, dynamic> variables = {};

  return QueryOptions(
    document: gql('''
      query adminSettings {
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
    variables: variables,
    fetchPolicy: FetchPolicy.noCache,
  );
}
