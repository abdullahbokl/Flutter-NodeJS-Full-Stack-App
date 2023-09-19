import 'package:flutter/material.dart';
import 'package:jobhub_flutter/features/chat/presentation/manager/chat_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/models/user_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../home/presentation/widgets/custom_circle_button.dart';
import '../../data/models/chat_model.dart';

class CustomChatCard extends StatelessWidget {
  const CustomChatCard({
    super.key,
    required this.chat,
    required this.receiver,
  });

  final ChatModel chat;
  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(receiver.profilePic.last),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: receiver.userName,
                  style: appStyle(
                    16,
                    AppColors.darkBlue,
                    FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                ReusableText(
                  text: chat.latestMessage!.content,
                  style: appStyle(
                    14,
                    AppColors.darkBlue,
                    FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ReusableText(
                  text: chatProvider.messageTime(chat.latestMessage!.createdAt),
                  style: appStyle(
                    14,
                    AppColors.darkBlue,
                    FontWeight.w400,
                  ),
                ),
              ),
              const CustomCircleButton(),
            ],
          ),
        ],
      ),
    );
  }
}
