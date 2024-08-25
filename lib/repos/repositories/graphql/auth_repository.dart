
import 'package:graphql_flutter/graphql_flutter.dart';

MutationOptions getLogInOptions(String phoneNumber) {
  return MutationOptions(
    document: gql('''
      mutation LogIn(\$phone: String!) {
        logIn(phone: \$phone)
      }
    '''),
    variables: {
      'phone': phoneNumber,
    },
  );
}

MutationOptions getVerifyTokenOptions(String id, String code) {
  return MutationOptions(
    document: gql('''
      mutation VerifyToken(\$id: String!, \$code: String!) {
        verifyToken(id: \$id, code: \$code)
      }
    '''),
    variables: {
      'id': id,
      'code': code,
    },
  );
}

MutationOptions getEditUserOptions(String name, String family, String username, String? photo, int? showActivity) {
  print('photo : $photo');
  Map<String, dynamic> variables = {
    'name': name,
    'family': family,
    'username': username,
    'show_activity': showActivity,
  };
  if (photo != null) variables['photo'] = photo;
  return MutationOptions(
    document: gql('''
      mutation EditUser(\$name: String!, \$family: String!, \$username: String, \$photo: String, \$show_activity: Int!) {
        editUser(name: \$name, family: \$family, username: \$username, photo: \$photo, show_activity: \$show_activity) {
          id,
          name,
          family,
          photo,
          field,
          biography,
          experience,
          address,
          office,
          is_expert,
          show_activity
        }
      }
    '''),
    variables: variables,
  );
}
