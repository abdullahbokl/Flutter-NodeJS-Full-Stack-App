import '../../../../core/common/models/user_model.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.sender,
    required super.content,
    super.receiver,
    super.readBy = const [],
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender.toMap(),
      'content': content,
      'receiver': receiver,
      'readBy':
          List<UserModel>.from(readBy.map((user) => user.toMap())),
      'createdAt': createdAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      sender: UserModel.fromMap(map['sender']),
      content: map['content'],
      receiver: map['receiver'],
      readBy: List<UserModel>.from(
        (map['readBy'] ?? const [])
            .map((userData) => UserModel.fromMap(userData)),
      ),
      createdAt: map['createdAt'],
    );
  }
}
