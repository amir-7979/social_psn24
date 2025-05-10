
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class ProfileSettingsRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> getProfile() =>
      _dio.get('/api/profile');

  Future<Response<dynamic>> getSettings() =>
      _dio.get('/api/setting');

  Future<Response<dynamic>> updateSettings(Map<String, dynamic> data) =>
      _dio.post('/api/setting/update', data: data);
}
