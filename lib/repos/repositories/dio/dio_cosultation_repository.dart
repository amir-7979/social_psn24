import 'package:dio/dio.dart';
import '../../../services/dio_auth_service.dart';

class RequestsRepository {
  final Dio _dio = DioAuthService.instance.client;

  Future<Response<dynamic>> getRequests() async => _dio.get('/collaboration');

  Future<Response<dynamic>> getRequestType() async => _dio.get('/collaboration/types');

  Future<Response<dynamic>> postRequest(String title, String description, String attachment,) async {
    FormData formData = FormData.fromMap({
      'attachment':
      await MultipartFile.fromFile(attachment, filename: 'attachment'),
    });
      Map<String, dynamic> variables = {
        'title': title ,
        'description': description,
        'attachment': formData,
      };

    return await _dio.post('/collaboration/store', data: variables);
  }

  Future<Response<dynamic>> cancelRequest(int id) async =>
      _dio.post('/collaboration/cancel/${id.toString()}');


}


