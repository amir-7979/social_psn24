
import 'package:dio/dio.dart';
import '../../../../services/dio_auth_service.dart';
import '../../../../services/dio_consultation_service.dart';

class InvoiceRepository {
  final Dio _dio = DioConsultationService.instance.client;

  Future<Response<dynamic>> bookSession(Map<String, dynamic> data) =>
      _dio.post('/api/invoice/store', data: data);

  Future<Response<dynamic>> getInvoices() =>
      _dio.get('/api/invoice/list');

  Future<Response<dynamic>> cancelInvoice(int id) =>
      _dio.post('/api/invoice/$id/cancel');
}