import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_back_button.dart';
import '../../../../core/common/widgets/user_avatar_image.dart';
import '../../../../core/common/widgets/vertical_list_shimmer.dart';
import '../manager/chat_provider.dart';
import '../widgets/conversation_page_body.dart';
import '../widgets/no_chats_widget.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).getMessages();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: customAppBar(
        title: chatProvider.receiver.userName,
        leading: const CustomBackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7),
            child: Stack(
              children: [
                UserAvatarImage(
                  imageUrl: chatProvider.receiver.profilePic.last,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const VerticalListShimmer();
          } else if (chatProvider.chats.isNotEmpty) {
            return const ConversationPageBody();
          } else {
            return const NoChatsWidget(message: 'No messages available');
          }
        },
      ),
    );
  }
}
