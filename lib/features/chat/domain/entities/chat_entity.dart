import 'package:equatable/equatable.dart';

import '../../../../core/common/models/user_model.dart';
import '../../data/models/message_model.dart';

class ChatEntity extends Equatable {
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<UserModel> users;
  final MessageModel? latestMessage;
  final UserModel? groupAdmin;

  const ChatEntity({
    required this.id,
    required this.chatName,
    this.isGroupChat = false,
    this.users = const [],
    this.latestMessage,
    this.groupAdmin,
  });

  @override
  List<Object?> get props => [
        id,
        chatName,
        isGroupChat,
        users,
        latestMessage,
        groupAdmin,
      ];
}
