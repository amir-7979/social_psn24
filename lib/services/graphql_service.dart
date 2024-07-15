import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggingLink extends Link {
  @override
  Stream<Response> request(Request request, [forward]) {
    // Optionally log the request and response
    return forward!(request).doOnData((response) {
      // Optionally log the response data
    });
  }
}

class GraphQLService {
  final StorageService _storageService = StorageService();
  final HttpLink _httpLink = HttpLink('https://api.psn24.ir/graphql');
  Link? _authLink;
  late Link _link;
  late GraphQLClient _client;

  GraphQLService._() {
    _initializeClient();
  }

  static final GraphQLService _instance = GraphQLService._();

  static GraphQLService get instance => _instance;

  GraphQLClient get client => _client;

  void _initializeClient() {
    final LoggingLink loggingLink = LoggingLink();
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null && token.isNotEmpty ? 'Bearer $token' : null;
      },
    );
    _link = Link.from([if (_authLink != null) _authLink!, loggingLink, _httpLink]);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  Future<void> addTokenToAuthLink() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _authLink = AuthLink(
        getToken: () async => 'Bearer $token',
      );
      _initializeClient();
    }
  }

  void removeTokenFromAuthLink() {
    _authLink = null;
    _initializeClient();
    _deleteFromStorage();
  }

  void _deleteFromStorage() {
    _storageService.deleteData('bearer');
    _storageService.deleteData('expiry');
    _storageService.deleteData('token');
    _storageService.deleteData('refreshToken');
    _storageService.deleteData('userId');
  }
}
