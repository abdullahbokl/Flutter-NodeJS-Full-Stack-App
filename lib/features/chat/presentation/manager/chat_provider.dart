import 'package:flutter/material.dart';

import '../../../../core/common/models/user_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/chat_repo_impl.dart';

class ChatProvider extends ChangeNotifier {
  ChatProvider() {
    _chatProviderLogger("ChatProvider initialized");
  }

  bool _isLoading = false;
  final _chatsRepoImpl = getIt<ChatRepoImpl>();
  final TextEditingController messageController = TextEditingController();
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  late ChatModel _currentChat;
  late UserModel _receiver;

  // getters
  bool get isLoading => _isLoading;

  List<MessageModel> get messages => _messages;

  List<ChatModel> get chats => _chats;

  ChatModel get currentChat => _currentChat;

  UserModel get receiver => _receiver;

  // setters
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set messages(List<MessageModel> messages) {
    _messages = messages;
    notifyListeners();
  }

  set currentChat(ChatModel chat) {
    _currentChat = chat;
  }

  set receiver(UserModel receiver) {
    _receiver = receiver;
  }

  getAllChats() async {
    isLoading = true;
    try {
      _chats = await _chatsRepoImpl.getAllChats();
    } catch (e) {
      rethrow;
    }
    isLoading = false;
  }

  getMessages() async {
    final chatId = currentChat.id;
    try {
      isLoading = true;
      final newMessages = await _chatsRepoImpl.getMessages(chatId);
      messages = newMessages;
    } catch (e) {
      rethrow;
    }
    isLoading = false;
  }

  sendMessage() async {
    try {
      final content = messageController.text;
      messageController.clear();
      final newMessage = await _chatsRepoImpl.sendMessage(
        chatId: currentChat.id,
        content: content,
        receiverId: receiver.id,
      );
      messages.add(newMessage);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  messageTime(String timeStamp) {
    final DateTime now = DateTime.now();
    final DateTime messageTime = DateTime.parse(timeStamp);

    final difference = now.difference(messageTime);
    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 30) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 365) {
      return "${difference.inDays / 30} months ago";
    } else {
      return "${difference.inDays / 365} years ago";
    }
  }

  @override
  void dispose() {
    _chatProviderLogger("ChatProvider disposed");

    super.dispose();
  }

  _chatProviderLogger(String event) {
    return Logger.logEvent(
      className: "ChatProvider",
      event: event,
    );
  }
}
