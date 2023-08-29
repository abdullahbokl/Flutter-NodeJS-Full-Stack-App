import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/chat_provider.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: chatProvider.messageController,
              decoration: const InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  // todo: typing
                } else {
                  // todo: not typing
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              chatProvider.sendMessage();
            },
            icon: const Icon(Icons.send),
            color: Colors.green[800],
          ),
        ],
      ),
    );
  }
}
