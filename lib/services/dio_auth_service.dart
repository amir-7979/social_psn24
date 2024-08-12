import 'package:dio/dio.dart';
import '../services/storage_service.dart';

class DioAuthService {
  final StorageService _storageService = StorageService();
  late Dio _dio;

  DioAuthService._() {
    _initializeClient();
  }

  static final DioAuthService _instance = DioAuthService._();
  static DioAuthService get instance => _instance;
  Dio get client => _dio;

  void _initializeClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://core.psn24.ir/u', // Set your base URL here
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
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
        onResponse: (response, handler) {
          print(response.data);
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          print(e.response?.data);
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> addToken() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
