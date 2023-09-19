import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/common/models/user_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_strings.dart';
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
  IO.Socket? socket;
  List<String> _onlineUsers = [];
  bool _isTyping = false;
  bool _isJoined = false;

  // getters
  bool get isLoading => _isLoading;

  List<MessageModel> get messages => _messages;

  List<ChatModel> get chats => _chats;

  ChatModel get currentChat => _currentChat;

  UserModel get receiver => _receiver;

  List<String> get onlineUsers => _onlineUsers;

  bool get isTyping => _isTyping;

  bool get isJoined => _isJoined;

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

  set onlineUsers(List<String> onlineUsers) {
    _onlineUsers = onlineUsers;
    notifyListeners();
  }

  set isTyping(bool isTyping) {
    _isTyping = isTyping;
    notifyListeners();
  }

  set isJoined(bool isJoined) {
    _isJoined = isJoined;
    notifyListeners();
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

  Future<List<MessageModel>> getMessages() async {
    final chatId = currentChat.id;
    try {
      final newMessages = await _chatsRepoImpl.getMessages(chatId);
      messages = newMessages;
      return messages;
    } catch (e) {
      rethrow;
    }
  }

  sendMessage({String? receiverId}) async {
    try {
      final content = messageController.text;
      messageController.clear();
      final newMessage = await _chatsRepoImpl.sendMessage(
        chatId: currentChat.id,
        content: content,
        receiverId: receiverId ?? receiver.id,
      );
      final Map<String, dynamic> newMessageData = newMessage.toMap();
      final Map<String, dynamic> chatData = currentChat.toMap();
      newMessageData['chat'] = chatData;
      socket!.emit('new-message', newMessageData);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  createChat({required String receiverId}) async {
    try {
      final chat = await _chatsRepoImpl.createChat(receiverId);
      currentChat = chat;
    } catch (error) {
      rethrow;
    }
  }

  socketConnect() {
    final socket = IO.io(
      'http://10.0.2.2:7000',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build(),
    );
    this.socket = socket;

    socket.emit('setup', AppStrings.userId);
    socket.connect();
    socket.onConnect((_) {
      _chatProviderLogger("Socket connected");
      socket.on('online-user', (userId) {
        onlineUsers.replaceRange(0, onlineUsers.length, [userId]);
      });
      socket.on('typing', (data) {
        _chatProviderLogger("Typing...");
        isTyping = true;
      });
      socket.on('stop-typing', (data) {
        _chatProviderLogger("Stop typing...");
        isTyping = false;
      });

      socket.on('join-chat', (chatId) {
        _chatProviderLogger("Joined chat");
        isJoined = true;
      });

      socket.on('message-received', (messageReceived) {
        _chatProviderLogger("message-received");
        MessageModel message = MessageModel.fromMap(messageReceived);
        messages.add(message);
        notifyListeners();
      });
    });
  }

  joinChat() {
    socket!.emit('join-chat', currentChat.id);
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
