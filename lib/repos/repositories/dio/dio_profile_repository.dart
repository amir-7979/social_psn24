import 'package:dio/dio.dart';
import '../../../services/dio_auth_service.dart';

class ProfileRepository {
  final Dio _dio = DioAuthService.instance.client;

  // Fetch the authenticated user's profile
  Future<Response<dynamic>> getProfile() async => _dio.get('/profile/me');

  // Update profile
  Future<Response<dynamic>> editProfile(
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
    return _dio.post(
      '/profile/update',
      data: variables,
    );
  }

  // Remove user profile photo
  Future<Response<dynamic>> removeProfilePhoto() async =>
      _dio.post('/profile/remove-photo');

  // Upload user profile photo
  Future<Response<dynamic>> uploadProfilePhoto(String filePath) async {
    FormData formData = FormData.fromMap({
      'photo':
      await MultipartFile.fromFile(filePath, filename: 'profile_photo'),
    });
    return await _dio.post('/profile/upload-photo', data: formData);
  }

  Future<Response<dynamic>> editOnlineStatus({required bool status}) async {
    Map<String, dynamic> variables = {
      'show_activity': status ? 1:0,
    };
    return _dio.post(
      '/profile/update',
      data: variables,
    );
  }

  Future<Response<dynamic>> getLimitation() async {
    return _dio.get(
      '/admin-settings',
    );
  }
}
