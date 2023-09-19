import '../../../../core/common/models/user_model.dart';
import '../../../../core/utils/app_strings.dart';
import 'message_model.dart';

class ChatModel {
  String id;
  String chatName;
  bool isGroupChat;
  List<UserModel> users;
  MessageModel? latestMessage;
  UserModel? groupAdmin;

  ChatModel({
    required this.id,
    required this.chatName,
    this.isGroupChat = false,
    this.users = const [],
    this.latestMessage,
    this.groupAdmin,
  });

  Map<String, dynamic> toMap() {
    final users = this.users.map((user) => user.toMap()).toList();
    return {
      AppStrings.chatLatestMessage: latestMessage?.toMap(),
      AppStrings.chatId: id,
      AppStrings.chatName: chatName,
      AppStrings.chatIsGroupChat: isGroupChat,
      AppStrings.chatUsers: users,
      AppStrings.chatGroupAdmin: groupAdmin?.toMap(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map[AppStrings.chatId],
      chatName: map[AppStrings.chatName],
      isGroupChat: map[AppStrings.chatIsGroupChat],
      users: List<UserModel>.from(
          map[AppStrings.chatUsers].map((user) => UserModel.fromMap(user))),
      latestMessage: map[AppStrings.chatLatestMessage] != null
          ? MessageModel.fromMap(map[AppStrings.chatLatestMessage])
          : null,
      groupAdmin: map[AppStrings.chatGroupAdmin] != null
          ? UserModel.fromMap(map[AppStrings.chatGroupAdmin])
          : null,
    );
  }
}
