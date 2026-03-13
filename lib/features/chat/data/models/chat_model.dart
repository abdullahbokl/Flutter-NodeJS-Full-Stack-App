import '../../../../core/common/models/user_model.dart';
import '../../domain/entities/chat_entity.dart';
import 'message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.chatName,
    super.isGroupChat = false,
    super.jobId,
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
      'jobId': jobId,
      'users': users,
      'groupAdmin': groupAdmin?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    final rawUsers = map['users'];
    final usersList = rawUsers is List ? rawUsers : const [];
    final rawJobId = map['jobId'];
    final parsedJobId = rawJobId is Map
        ? (rawJobId['id'] ?? rawJobId['_id'])?.toString()
        : rawJobId?.toString();

    return ChatModel(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      chatName: (map['chatName'] ?? 'direct').toString(),
      isGroupChat: map['isGroupChat'] == true,
      jobId: parsedJobId,
      users: List<UserModel>.from(
        usersList.map((user) => UserModel.fromMap(user)),
      ),
      latestMessage: map['latestMessage'] != null
          ? MessageModel.fromMap(
              Map<String, dynamic>.from(map['latestMessage'] as Map),
            )
          : null,
      groupAdmin: map['groupAdmin'] != null
          ? UserModel.fromMap(Map<String, dynamic>.from(map['groupAdmin'] as Map))
          : null,
    );
  }
}
