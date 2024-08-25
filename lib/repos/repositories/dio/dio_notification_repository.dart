import 'package:dio/dio.dart';
import '../../../services/dio_auth_service.dart';

class NotificationRepository {
  final Dio _dio = DioAuthService.instance.client;

  // Fetch user notifications
  Future<Response<dynamic>> fetchNotifications() async {
    return _dio.get('/notification', queryParameters: {'user': null});
  }

  // Mark notifications as read
  Future<Response<dynamic>> markAsRead() async {
    return _dio.post('/notification/mark-as-seen');
  }

  // Send batch notifications
  Future<Response<dynamic>> batchSendNotifications(Map<String, dynamic> notificationData) async {
    return _dio.post('/notification/batch-send', data: notificationData);
  }

  // Set FCM token
  Future<Response<dynamic>> setFcmToken(String fcmToken) async {
    return _dio.post(
      '/notification/set-token',
      data: {'token': fcmToken},
    );
  }

  // Send a notification
  Future<Response<dynamic>> sendNotification(Map<String, dynamic> notificationData) async {
    return _dio.post(
      '/notification/send',
      data: notificationData,
    );
  }

  // My notifications
  Future<Response<dynamic>> fetchMyNotifications() async {
    return _dio.get('/notification');
  }
}