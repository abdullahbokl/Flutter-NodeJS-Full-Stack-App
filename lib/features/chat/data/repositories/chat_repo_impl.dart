import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  final ApiServices _apiService;

  ChatRepoImpl(this._apiService);

  @override
  Future<List<ChatModel>> getAllChats() async {
    try {
      final chatsData = await _apiService.get(endPoint: AppStrings.apiChatsUrl);
      final List<ChatModel> chatModels = [];
      for (var chat in chatsData) {
        if (chat[AppStrings.chatLatestMessage] != null) {
          chatModels.add(ChatModel.fromMap(chat));
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
      final messages = await _apiService.get(
          endPoint: "${AppStrings.apiMessagesUrl}/$chatId");
      final List<MessageModel> messageModels = [];
      for (var message in messages) {
        messageModels.add(MessageModel.fromMap(message));
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
        endPoint: AppStrings.apiMessagesUrl,
        data: {
          AppStrings.chatId: chatId,
          AppStrings.messageContent: content,
          AppStrings.messageReceiver: receiverId,
        },
      );
      MessageModel message = MessageModel.fromMap(messageData);
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
        endPoint: AppStrings.apiChatsUrl,
        data: {
          'receiverId': receiverId,
        },
      );
      final ChatModel chat = ChatModel.fromMap(chatData);
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
