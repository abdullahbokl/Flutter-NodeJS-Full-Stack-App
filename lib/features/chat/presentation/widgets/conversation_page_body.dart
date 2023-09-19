import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/chat_provider.dart';
import 'message_input.dart';
import 'messages_list.dart';

class ConversationPageBody extends StatefulWidget {
  const ConversationPageBody({super.key});

  @override
  State<ConversationPageBody> createState() => _ConversationPageBodyState();
}

class _ConversationPageBodyState extends State<ConversationPageBody> {
  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).joinChat();

    super.initState();
  }

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
