import '../../../../core/common/models/user_model.dart';
import '../../../../core/utils/app_strings.dart';
import 'message_model.dart';

class ChatModel {
  String id;
  String chatName;
  bool isGroupChat;
  List<UserModel> users;
  MessageModel latestMessage;
  UserModel? groupAdmin;

  ChatModel({
    required this.id,
    required this.chatName,
    this.isGroupChat = false,
    this.users = const [],
    required this.latestMessage,
    this.groupAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      AppStrings.chatId: id,
      AppStrings.chatName: chatName,
      AppStrings.chatIsGroupChat: isGroupChat,
      AppStrings.chatUsers:
          List<UserModel>.from(users.map((user) => user.toMap())),
      AppStrings.chatLatestMessage: latestMessage.toMap(),
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
      latestMessage: MessageModel.fromMap(map[AppStrings.chatLatestMessage]),
      groupAdmin: map[AppStrings.chatGroupAdmin] != null
          ? UserModel.fromMap(map[AppStrings.chatGroupAdmin])
          : null,
    );
  }
}
