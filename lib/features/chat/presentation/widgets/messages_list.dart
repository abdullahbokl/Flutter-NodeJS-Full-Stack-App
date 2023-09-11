import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../manager/chat_provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          color: Colors.green[50],
          child: ListView.builder(
            reverse: true,
            itemCount: chatProvider.messages.length,
            itemBuilder: (context, index) {
              bool isMe =
                  chatProvider.messages[index].sender.id == AppConstants.userId;
              return Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMe) ...[
                    CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                        chatProvider.receiver.profilePic.last,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  ChatBubble(
                    margin: EdgeInsets.only(
                      top: 10,
                      left: isMe ? 50 : 0,
                      right: isMe ? 0 : 50,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                    backGroundColor:
                        isMe ? Colors.green[800] : AppColors.lightGrey,
                    clipper: ChatBubbleClipper4(
                      type: isMe
                          ? BubbleType.sendBubble
                          : BubbleType.receiverBubble,
                      radius: 10,
                    ),
                    child: Text(
                      chatProvider.messages[index].content,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
