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

class GraphQLService {
  final StorageService _storageService = StorageService();
  final HttpLink _httpLink = HttpLink('https://api.psn24.ir/graphql');
  late AuthLink _authLink;
  late Link _link;
  late GraphQLClient _client;

  GraphQLService._() {
    _authLink = AuthLink(
      getToken: () async {
        final token = await _storageService.readData('token');
        return token != null ? 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiZTczMGZmOGJlYzExNDg5MTU5NzFmMjVhZjk2MWU4ZDQyMjlkNTA5NDM1Y2ZhMDAyNGJjODU0ZjQ4ZmIyNWMwNTNhODFjNjg5ZDkzNjlkZGIiLCJpYXQiOjE3MDE2MDk5MzQuNzIzMTQ1LCJuYmYiOjE3MDE2MDk5MzQuNzIzMTUxLCJleHAiOjE3MzMyMzIzMzQuNzExOTgzLCJzdWIiOiIyOSIsInNjb3BlcyI6W119.JNuVRArx33hOUGVoXyEr81qfxV85RIBorwramkvk2Lev8SfHs9O3MDLLv8rKc1qQ5v7I_s9cDeNjYW4sPAZLF5X_FS17_3xxO__2mAY07qBdmL_82jUAGUQMA0c6cx3OsGEXiiCQo-v2D2vSYo-ydqKy-y6wJ4J4SiXedlDNAoLzbN1Nn_aDHrsXdP9lthG-YLB5oIFNr-3wNPt582Zl2bjr_jBit_yt5sHCPOIpCHYsc3G-NoM_AGAsJSlarK5A7GtxEo11J-3i_Tq2rv3xdIIsrX7nlMvWXqDi2dWAqInT0TbyEBZoXBUKchlFb1TuVsxJekw9-nNEyUjZ9Po1dcNKWQWAS2Mlv0jZbxY2a7rm_XL9z6XbHUxU-0rq27srQd8OZAfh-t0Y59Ke11LxfS1Jw_LUzZrRVHzypQI5gcudY5Fti5yo4r9iJ1OUiu77gp-eYIQAPzD1AiyuL6xQup3dGL2Rlayhyjw9NQM5fj7_OdkYBZyr5aZd0ztATUnm4E2wAmF02SvR7pLw94HJFcBU9tIa38fcZ9JqiSZ6fDkTiHUAFHBoaCbvvb2YdizlDqt8yZf2_I0P12vzT55_yqJ3tIEMU75bbuhyA0sZJvMEOSHaOcIX2n2_GybAmJOkWbiPTlJiGaBp6420Zh9AgZ-SstADjPfGuTpO1gIhUGo' : null;
      },
    );
    final LoggingLink loggingLink = LoggingLink();
    _link = _authLink.concat(loggingLink).concat(_httpLink);
    _client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
  }

  static final GraphQLService _instance = GraphQLService._();

  static GraphQLService get instance => _instance;

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
    deleteFromStorage();

  }

  void deleteFromStorage() {
    _storageService.deleteData('bearer');
    _storageService.deleteData('expiry');
    _storageService.deleteData('token');
    _storageService.deleteData('refreshToken');
    _storageService.deleteData('userId');
  }
}