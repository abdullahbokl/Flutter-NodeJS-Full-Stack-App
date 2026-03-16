import '../../../../../../core/utils/app_session.dart';
import '../../../../../../core/common/models/user_model.dart';
import '../../../../data/models/chat_model.dart';

UserModel resolveOtherParticipant(ChatModel chat) {
  return chat.users.firstWhere(
    (user) => user.id != AppSession.userId,
    orElse: () => chat.users.first,
  );
}
