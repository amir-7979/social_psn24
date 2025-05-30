import 'package:dio/dio.dart';
import '../../../../services/dio_chat_service.dart';

class ChatRepository {
  final Dio _dio = DioChatService.instance.client;

  Future<Response<dynamic>> fetchMessages(String chatUuid) {
    return _dio.get('/api/messages/$chatUuid');

  }

  Future<Response<dynamic>> sendMessage(String chatUuid, String message) {
    return _dio.post(
      '/api/messages/$chatUuid',
      data: {'message': message},
    );
  }

  Future<Response<dynamic>> cancelConversation(String conversationUuid) {
    return _dio.post('/api/conversations/$conversationUuid/finish');
  }


 Future<Response<dynamic>> getConversationStatus(String conversationUuid) {
    return _dio.get('/api/conversations/$conversationUuid/status');
  }

  Future<Response<dynamic>> getMessagesListPagination(String chatUuid, int page) {
    return _dio.get('/api/messages/$chatUuid?messages_list_pagination=$page');
  }
}
