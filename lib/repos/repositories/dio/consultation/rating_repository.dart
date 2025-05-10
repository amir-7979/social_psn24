
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class RatingRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> rateConsultant(Map<String, dynamic> data) =>
      _dio.post('/api/rate/store', data: data);

  Future<Response<dynamic>> getUserRatings() =>
      _dio.get('/api/rate/list');

  Future<Response<dynamic>> getRateableConsultants() =>
      _dio.get('/api/rate/ratability');
}
