
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class WeeklyScheduleRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> getSchedule(int centerId) =>
      _dio.get('/api/weekly-schedule/list/$centerId');

  Future<Response<dynamic>> createSchedule(Map<String, dynamic> data) =>
      _dio.post('/api/weekly-schedule/store', data: data);

  Future<Response<dynamic>> deleteSchedule(int id) =>
      _dio.post('/api/weekly-schedule/delete/$id');
}
