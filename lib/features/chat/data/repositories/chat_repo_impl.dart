import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ApiServices _apiService;

  ChatRepoImpl(this._apiService);

  @override
  Future<List<ChatModel>> getAllChats() async {
    try {
      final raw = await _apiService.get(endPoint: ApiEndpoints.chats);
      final chatsData = raw is Map ? raw['data'] : raw;
      if (chatsData is! List) return [];
      final List<ChatModel> chatModels = [];
      for (final chat in chatsData) {
        if (chat['latestMessage'] != null) {
          chatModels.add(ChatModel.fromMap(Map<String, dynamic>.from(chat)));
        }
      }

      return chatModels;
    } catch (e) {
      Logger.logEvent(
        className: "ChatRepoImpl",
        event: handleServerError(e),
        methodName: "getAllChats",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final raw = await _apiService.get(
          endPoint: "${ApiEndpoints.messages}/$chatId");
      final messages = raw is Map ? raw['data'] : raw;
      if (messages is! List) return [];
      final List<MessageModel> messageModels = [];
      for (final message in messages) {
        messageModels
            .add(MessageModel.fromMap(Map<String, dynamic>.from(message)));
      }

      return messageModels;
    } catch (e) {
      Logger.logEvent(
        className: "ChatRepoImpl",
        event: handleServerError(e),
        methodName: "getMessages",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required String receiverId,
  }) async {
    try {
      final messageData = await _apiService.post(
        endPoint: ApiEndpoints.messages,
        data: {
          'id': chatId,
          'content': content,
          'receiver': receiverId,
        },
      );
      final data = messageData is Map && messageData['data'] != null
          ? messageData['data']
          : messageData;
      final MessageModel message =
          MessageModel.fromMap(Map<String, dynamic>.from(data));
      return message;
    } catch (e) {
      Logger.logEvent(
        className: "ChatRepoImpl",
        event: handleServerError(e),
        methodName: "sendMessage",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<ChatModel> createChat(String receiverId) async {
    try {
      final chatData = await _apiService.post(
        endPoint: ApiEndpoints.chats,
        data: {
          'userId': receiverId,
        },
      );
      final data = chatData is Map && chatData['data'] != null
          ? chatData['data']
          : chatData;
      final ChatModel chat = ChatModel.fromMap(Map<String, dynamic>.from(data));
      return chat;
    } catch (e) {
      Logger.logEvent(
        className: "ChatRepoImpl",
        event: handleServerError(e),
        methodName: "createChat",
      );
      throw handleServerError(e);
    }
  }
}
