
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class LocationRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> getProvinces() =>
      _dio.get('/api/provinces');

  Future<Response<dynamic>> getCities(int provinceId) =>
      _dio.get('/api/provinces/$provinceId');
}
