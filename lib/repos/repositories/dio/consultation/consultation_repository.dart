
import 'package:dio/dio.dart';
import '../../../../services/dio_consultation_service.dart';

class ConsultationRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> createConsultation(Map<String, dynamic> data) =>
      _dio.post('/api/consultation/store', data: data);

  Future<Response<dynamic>> getConsultations() =>
      _dio.get('/api/consultation/list');

  Future<Response<dynamic>> deleteConsultation(int id) =>
      _dio.post('/api/consultation/delete', data: {'id': id});

  Future<Response<dynamic>> markConsultationDone(int id) =>
      _dio.post('/api/consultation/$id/done');
}
