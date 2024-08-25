import 'package:dio/dio.dart';

import '../../../services/dio_auth_service.dart';

class ProfileRepository {
  final Dio _dio = DioAuthService.instance.client;

  Future<Response<dynamic>> getProfile() async {
    return _dio.get('/u/profile');
  }

  Future<Response<dynamic>> updateProfile(
      {required String firstName,
      required String lastName,
      String? username,
      String? photo}) async {
    Map<String, dynamic> variables = {
      'name': firstName,
      'family': lastName,
    };
    if (username != null) {
      variables['username'] = username;
    }
    if (photo != null) {
      variables['photo'] = photo;
    }
    return _dio.put(
      '/u/profile',
      data: variables,
    );
  }

  // Fetch the authenticated user's profile
  Future<Response<dynamic>> whoAmI() async {
    return _dio.get('/u/profile/me');
  }

  // Remove user profile photo
  Future<Response<dynamic>> removeProfilePhoto() async {
    return _dio.post('/u/profile/remove-photo');
  }

  // Upload user profile photo
  Future<Response<dynamic>> uploadProfilePhoto(String filePath) async {
    FormData formData = FormData.fromMap({
      'photo':
          await MultipartFile.fromFile(filePath, filename: 'profile_photo.jpg'),
    });
    return await _dio.post('/u/profile/upload-photo', data: formData);
  }
}
