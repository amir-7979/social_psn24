import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggingLink extends Link {
  @override
  Stream<Response> request(Request request, [forward]) {
    return forward!(request).doOnData((response) {
      print('Response: ${response.data}');
    });
  }
}

class CoreGraphQLService {
  final StorageService _storageService = StorageService();
  final HttpLink _httpLink = HttpLink('https://core.psn24.ir/graphql');
  late AuthLink _authLink;
  late Link _link;
  late GraphQLClient _client;

  static final CoreGraphQLService _instance = CoreGraphQLService._();

  static CoreGraphQLService get instance => _instance;

  GraphQLClient get client => _client;

  CoreGraphQLService._() {
    _initializeClient();

  }

  // Initialize the GraphQL client with or without an auth link
  void _initializeClient() {
    // Create the AuthLink and LoggingLink
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null && token.isNotEmpty ? 'Bearer $token' : null;
      },
    );
    final LoggingLink loggingLink = LoggingLink();

    // Configure the link to include AuthLink if a token is present
    _link = Link.from([
      _authLink,
      loggingLink,
      _httpLink,
    ]);

    // Create the GraphQL client
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  // Add token to AuthLink and reinitialize the client
  Future<void> addTokenToAuthLink() async {
    final token = await _storageService.readData('token');
    if (token != null && token.isNotEmpty) {
      _authLink = AuthLink(
        getToken: () async => 'Bearer $token',
      );
      _initializeClient();
    }
  }

  // Remove token from AuthLink and reinitialize the client
  Future<void> removeTokenFromAuthLink() async {
    _authLink = AuthLink(
      getToken: () async => null, // Ensure no token is used
    );
    _initializeClient();
  }
}