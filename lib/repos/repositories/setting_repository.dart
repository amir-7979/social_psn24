import 'package:graphql_flutter/graphql_flutter.dart';


QueryOptions adminSettings() {
  return QueryOptions(
    document: gql('''
      query adminSettings {
        adminSettings {
          max_size_for_media_mb,
          // ... include all other fields here ...
          is_active,
        }
      }
    '''),
    fetchPolicy: FetchPolicy.noCache,
  );
}

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
