import '../../../../core/common/models/user_model.dart';
import '../../domain/entities/chat_entity.dart';
import 'message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.chatName,
    super.isGroupChat = false,
    super.users = const [],
    super.latestMessage,
    super.groupAdmin,
  });

  Map<String, dynamic> toMap() {
    final users = this.users.map((user) => user.toMap()).toList();
    return {
      'latestMessage': latestMessage?.toMap(),
      'id': id,
      'chatName': chatName,
      'isGroupChat': isGroupChat,
      'users': users,
      'groupAdmin': groupAdmin?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      chatName: map['chatName'],
      isGroupChat: map['isGroupChat'],
      users: List<UserModel>.from(
          map['users'].map((user) => UserModel.fromMap(user))),
      latestMessage: map['latestMessage'] != null
          ? MessageModel.fromMap(map['latestMessage'])
          : null,
      groupAdmin: map['groupAdmin'] != null
          ? UserModel.fromMap(map['groupAdmin'])
          : null,
    );
  }
}
