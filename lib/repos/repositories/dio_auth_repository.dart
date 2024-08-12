import 'package:dio/dio.dart';
import '../../services/dio_auth_service.dart';

class AuthRepository {
  final Dio _dio = DioAuthService.instance.client;

  Future<Response<dynamic>> logIn(String phoneNumber) async {
    return _dio.post('/login', data: {'phone': phoneNumber});
  }

  Future<Response<dynamic>> verifyToken(int loginId, String code) async {
    return _dio.post('/verify', data: {'id': loginId, 'code': code,});
  }
}
