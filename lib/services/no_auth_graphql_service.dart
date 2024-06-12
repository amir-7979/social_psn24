import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/storage_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggingLink extends Link {
  @override
  Stream<Response> request(Request request, [forward]) {
    return forward!(request).doOnData((response) {});
  }
}

class NoAuthGraphQLService {
  final HttpLink _httpLink = HttpLink('https://api.psn24.ir/graphql');
  late Link _link;
  late GraphQLClient _client;

  NoAuthGraphQLService._() {
    final LoggingLink loggingLink = LoggingLink();
    _link = loggingLink.concat(_httpLink);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  static final NoAuthGraphQLService _instance = NoAuthGraphQLService._();

  static NoAuthGraphQLService get instance => _instance;

  GraphQLClient get client => _client;
}