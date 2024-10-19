
import 'package:dio/dio.dart';
import 'package:gql_dio_link/gql_dio_link.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/storage_service.dart';

class GraphQLService {
  final StorageService _storageService = StorageService();
  final HttpLink _httpLink = HttpLink('https://api.psn24.ir/graphql');
  late AuthLink _authLink;
  late Link _link;
  late Dio _dio;
  late DioLink _dioLink;
  late GraphQLClient _client;

  GraphQLService._() {
    _initializeDio();
    _initializeClient();
  }

  static final GraphQLService _instance = GraphQLService._();

  static GraphQLService get instance => _instance;

  GraphQLClient get client => _client;

  Dio get dio => _dio; // Expose the Dio instance

  void _initializeDio() async {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.psn24.ir/graphql',
      headers: {'Content-Type': 'application/json'},
    ));
    await _setDioAuthHeader(); // Set the initial token if available
  }

  void _initializeClient() {
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null && token.isNotEmpty ? 'Bearer $token' : null;
      },
    );

    _dioLink = DioLink('https://api.psn24.ir/graphql', client: _dio);

    _link = Link.from([
      _authLink,
      _httpLink,
      _dioLink,
    ]);

    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  Future<void> _setDioAuthHeader() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> updateDioToken() async {
    await _setDioAuthHeader(); // Update Dio's authorization header with the new token
  }

  Future<void> addTokenToAuthLink() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _authLink = AuthLink(
        getToken: () async => 'Bearer $token',
      );
      _initializeClient();
      await updateDioToken(); // Also update Dio's token when AuthLink is updated
    }
  }

  Future<void> removeTokenFromAuthLink() async {
    _authLink = AuthLink(
      getToken: () async => null,
    );
    _initializeClient();
    _dio.options.headers.remove('Authorization'); // Remove the token from Dio's headers
  }
}
