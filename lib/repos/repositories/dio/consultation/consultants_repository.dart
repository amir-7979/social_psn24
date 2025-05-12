
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class ConsultantsRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> getConsultants() =>
      _dio.get('/api/consultants');

  Future<Response<dynamic>> getMostActiveConsultants() =>
      _dio.get('/api/consultants/most-active');

  Future<Response<dynamic>> getSuggestedConsultants() =>
      _dio.get('/api/consultants/suggested');

  Future<Response<dynamic>> getAvailability(int consultantId) =>
      _dio.get('/api/consultants/$consultantId/availability');

  Future<Response<dynamic>> getCounselingCenters() =>
      _dio.get('/api/consultants/centers');

  Future<Response<dynamic>> createCenter(Map<String, dynamic> data) =>
      _dio.post('/api/counseling-center/store', data: data);

  Future<Response<dynamic>> updateCenter(Map<String, dynamic> data) =>
      _dio.post('/api/counseling-center/update', data: data);

}
