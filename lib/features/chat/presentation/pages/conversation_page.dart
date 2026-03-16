import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_setup.dart';
import '../../data/models/chat_model.dart';
import '../bloc/messages_cubit.dart';
import 'conversation/conversation_view.dart';

class ConversationPage extends StatelessWidget {
  final ChatModel? chat;

  const ConversationPage({
    super.key,
    this.chat,
  });

  @override
  Widget build(BuildContext context) {
    if (chat == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Chat not found')),
      );
    }

    return BlocProvider(
      create: (_) => getIt<MessagesCubit>()
        ..loadMessages(chat!.id)
        ..connectSocket(chat!.id),
      child: ConversationView(chat: chat!),
    );
  }
}
