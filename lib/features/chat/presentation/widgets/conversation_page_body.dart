import 'package:flutter/material.dart';

import 'message_input.dart';
import 'messages_list.dart';

class ConversationPageBody extends StatelessWidget {
  const ConversationPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: MessagesList()),
        MessageInput(),
        SizedBox(height: 5),
      ],
    );
  }
}
