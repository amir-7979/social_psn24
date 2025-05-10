
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class CounselingCenterRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> getCounselingCenters() =>
      _dio.get('/api/counseling-centers');

  Future<Response<dynamic>> createCenter(Map<String, dynamic> data) =>
      _dio.post('/api/counseling-center/store', data: data);

  Future<Response<dynamic>> updateCenter(Map<String, dynamic> data) =>
      _dio.post('/api/counseling-center/update', data: data);
}
