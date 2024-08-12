import 'package:dio/dio.dart';

import '../../services/dio_auth_service.dart';

class ProfileRepository {
  final Dio _dio = DioAuthService.instance.client;

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get('/u/profile');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('خطا در دریافت اطلاعات');
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'خطا در دریافت اطلاعات');
    }
  }

  Future<Map<String, dynamic>> updateProfile({required String firstName, required String lastName,}) async {
    Map<String, dynamic> variables = {
      'name': firstName,
      'family': lastName,
    };
    try {
      final response = await _dio.put(
        '/u/profile',
        data: variables,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update profile');
      }
    } on DioError catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Profile update error');
    }
  }
}