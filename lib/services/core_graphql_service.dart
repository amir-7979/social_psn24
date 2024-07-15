import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggingLink extends Link {
  @override
  Stream<Response> request(Request request, [forward]) {
    //print('Request: ${request.hashCode}');
    return forward!(request).doOnData((response) {
      //print('Response: ${response.data}');
    });
  }
}

class CoreGraphQLService {
  final StorageService _storageService = StorageService();
  final HttpLink _httpLink = HttpLink('https://core.psn24.ir/graphql');
  late AuthLink _authLink;
  late Link _link;
  late GraphQLClient _client;

  CoreGraphQLService._() {
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null ? 'Bearer $token' : null;
      },
    );
    final LoggingLink loggingLink = LoggingLink();
    _link = _authLink.concat(loggingLink).concat(_httpLink);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  static final CoreGraphQLService _instance = CoreGraphQLService._();

  static CoreGraphQLService get instance => _instance;

  GraphQLClient get client => _client;

  void addTokenToAuthLink() {
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null ? 'Bearer $token' : null;
      },
    );
    final LoggingLink loggingLink = LoggingLink();
    _link = _authLink.concat(loggingLink).concat(_httpLink);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  void removeTokenFromAuthLink() {
    _authLink = AuthLink(
      getToken: () => Future.value(null),
    );
    final LoggingLink loggingLink = LoggingLink();
    _link = _authLink.concat(loggingLink).concat(_httpLink);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );

  }


}