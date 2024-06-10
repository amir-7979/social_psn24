import 'package:graphql_flutter/graphql_flutter.dart';

QueryOptions postsQuery({String? id, int? isPublish, int? tagId, String? search, int? limit, int? offset, int? postType}) {
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
        query postsQuery(\$id: String, \$isPublish: Int, \$tagId: Int, \$search: String, \$limit: Int, \$offset: Int, \$postType: Int) {
          posts(id: \$id, is_publish: \$isPublish, tag_id: \$tagId, search: \$search, limit: \$limit, offset: \$offset, post_type: \$postType) {
            id, tag_id, name, description, created_at, current_user_liked, current_user_up_votes, current_user_down_votes, current_user_notification_enabled, post_type, is_publish,
            comments_count, down_votes, up_votes, view_count, medias {
              id, loc, type, thumbnails {
                id, loc, type
              }
            }, creator {
              id, name, family, username, photo, online, display_name, show_activity
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

QueryOptions getTags() {
  return QueryOptions(
    document: gql('''
        query getTags {
          tags {
            id, title, type
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
        query getComments(\$postId: String, \$type: String, \$userId: Int, \$limit: Int, \$offset: Int) {
          comments(post_id: \$postId, type: \$type, user_id: \$userId, limit: \$limit, offset: \$offset) {
            id, message, created_at, reply_to,
            replies {
              id, message, created_at, reply_to, sender_id {
                id, name, family, photo, username,
              }
            }
            sender_id {
              id, name, family, photo, username,
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
        query getCommentsWithPostData(\$postId: String, \$type: String, \$userId: Int, \$limit: Int, \$offset: Int) {
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

MutationOptions createPost() {
  return MutationOptions(
    document: gql('''
        mutation createPost {
          createPost(status: 0, is_publish: 0) {
            id,
          }
        }
      '''),
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

MutationOptions uploadMediaFile({dynamic mediaFile, String? postId}) {
  Map<String, dynamic> variables = {};
  if (mediaFile != null) variables['mediaFile'] = mediaFile;
  if (postId != null) variables['postId'] = postId;

  return MutationOptions(
    document: gql('''
        mutation uploadMediaFile(\$mediaFile: Upload!, \$postId: String!) {
          PostMedia(mediaFile: \$mediaFile, post_id: \$postId) {
            id, loc, type,
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

MutationOptions enableNotification(String postId) {
  return MutationOptions(
    document: gql('''
        mutation enableNotification(\$postId: String) {
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

MutationOptions createComment({String? postId, String? message, String? replyTo}) {
  Map<String, dynamic> variables = {};
  if (postId != null) variables['postId'] = postId;
  if (message != null) variables['message'] = message;
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

MutationOptions deleteMedia(String mediaId) {
  return MutationOptions(
    document: gql('''
        mutation deleteMedia(\$mediaId: String!) {
          DeleteMedia(id: \$mediaId)
        }
      '''),
    variables: {'mediaId': mediaId},
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
