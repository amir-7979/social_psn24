import 'package:dio/dio.dart';
import '../../../services/dio_auth_service.dart';

class NotificationRepository {
  final Dio _dio = DioAuthService.instance.client;

  Future<Response<dynamic>> fetchNotifications() async {
    return _dio.get('/notification', queryParameters: {'user': null});
  }

  Future<Response<dynamic>> markAsRead() async {
    return _dio.post('/notification/mark-as-read');
  }

  Future<Response<dynamic>> setFirebaseToken(String token) async {
    return _dio.post('/notification/set-token', data: {'token': token});
  }

}