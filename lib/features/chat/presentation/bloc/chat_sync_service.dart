import 'dart:async';

import '../../data/models/message_model.dart';

class ChatSyncEvent {
  final String chatId;
  final MessageModel message;

  const ChatSyncEvent({
    required this.chatId,
    required this.message,
  });
}

class ChatSyncService {
  final StreamController<ChatSyncEvent> _controller =
      StreamController<ChatSyncEvent>.broadcast();

  Stream<ChatSyncEvent> get stream => _controller.stream;

  void publish(ChatSyncEvent event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}

