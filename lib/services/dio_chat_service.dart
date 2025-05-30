import 'package:dio/dio.dart';
import '../secret.dart';
import '../services/storage_service.dart';

class DioChatService {
  final StorageService _storageService = StorageService();
  late Dio _dio;

  DioChatService._() {
    _initializeClient();
  }

  static final DioChatService _instance = DioChatService._();
  static DioChatService get instance => _instance;
  Dio get client => _dio;

  void _initializeClient() {
    _dio = Dio(

      BaseOptions(
        baseUrl: 'https://chat.psn24.ir',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Http-Service-Type': 'mobile',
          'service-token': Secret2,
          'Http-Service-Secret':Secret
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.readData('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (DioError e, handler) => handler.next(e),
      ),
    );
  }

  Future<void> addToken() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  void removeToken() async {
    _dio.options.headers.remove('Authorization');
  }
}
