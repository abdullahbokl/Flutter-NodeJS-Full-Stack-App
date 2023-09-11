import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRepo {
  Future<List<ChatModel>> getAllChats();

  Future<List<MessageModel>> getMessages(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String receiverId,
  });
}
