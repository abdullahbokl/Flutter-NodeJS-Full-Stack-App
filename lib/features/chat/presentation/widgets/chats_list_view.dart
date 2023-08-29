import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_constants.dart';
import '../manager/chat_provider.dart';
import 'custom_chat_card.dart';

class ChatsListView extends StatelessWidget {
  const ChatsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final receiver = chatProvider.chats[index].users.firstWhere(
                (user) => user.id != AppConstants.userId,
              );
              return GestureDetector(
                  onTap: () {
                    chatProvider.currentChat = chatProvider.chats[index];
                    chatProvider.receiver = receiver;
                    Navigator.pushNamed(context, AppRouter.conversationPage);
                  },
                  child: CustomChatCard(
                    chat: chatProvider.chats[index],
                    receiver: receiver,
                  ));
            },
          );
        },
      ),
    );
  }
}
