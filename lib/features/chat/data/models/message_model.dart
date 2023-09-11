import '../../../../core/common/models/user_model.dart';
import '../../../../core/utils/app_strings.dart';

class MessageModel {
  String id;
  UserModel sender;
  String content;
  String? receiver;
  List<UserModel> readBy;
  String createdAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.content,
    this.receiver,
    this.readBy = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      AppStrings.messageId: id,
      AppStrings.messageSender: sender.toMap(),
      AppStrings.messageContent: content,
      AppStrings.messageReceiver: receiver,
      AppStrings.messageReadBy:
          List<UserModel>.from(readBy.map((user) => user.toMap())),
      AppStrings.messageCreatedAt: createdAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map[AppStrings.messageId],
      sender: UserModel.fromMap(map[AppStrings.messageSender]),
      content: map[AppStrings.messageContent],
      receiver: map[AppStrings.messageReceiver],
      readBy: List<UserModel>.from(map[AppStrings.messageReadBy]
          .map((userData) => UserModel.fromMap(userData))),
      createdAt: map[AppStrings.messageCreatedAt],
    );
  }
}
