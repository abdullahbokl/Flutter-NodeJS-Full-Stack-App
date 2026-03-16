import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/base_state.dart';
import '../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../core/navigation/app_navigation.dart';
import '../../../../../core/utils/app_snackbars.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/message_model.dart';
import '../../bloc/messages_cubit.dart';
import 'support/conversation_participant.dart';
import '../../widgets/conversation/conversation_header.dart';
import '../../widgets/conversation/message_input_row.dart';
import '../../widgets/conversation/messages_list.dart';
import '../../widgets/conversation/typing_indicator.dart';

class ConversationView extends StatefulWidget {
  final ChatModel chat;

  const ConversationView({super.key, required this.chat});

  @override
  State<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<ConversationView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _scrollToLatestTimer;

  String get _otherId => resolveOtherParticipant(widget.chat).id;
  String get _otherName =>
      resolveOtherParticipant(widget.chat).fullName ??
      resolveOtherParticipant(widget.chat).userName;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagesCubit, BaseState<List<MessageModel>>>(
      listenWhen: (_, current) {
        return current is MessagesSendError ||
            current is SuccessState<List<MessageModel>>;
      },
      listener: (context, state) {
        if (state is MessagesSendError) {
          AppSnackBars.showError(
            context,
            'Failed to send: ${state.errorMessage}',
          );
          return;
        }

        if (state is SuccessState<List<MessageModel>>) {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _scrollToLatest());
        }
      },
      child: PremiumScaffold(
        child: Column(
          children: [
            ConversationHeader(
              name: _otherName,
              onBack: () => AppNavigation.popOrGoHome(context),
            ),
            Expanded(
              child: MessagesList(
                scrollController: _scrollController,
                otherName: _otherName,
              ),
            ),
            ConversationTypingIndicator(
              typingListenable: context.read<MessagesCubit>().typingListenable,
            ),
            MessageInputRow(
              controller: _controller,
              chatId: widget.chat.id,
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToLatest() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    _controller.clear();
    context.read<MessagesCubit>().sendMessage(widget.chat.id, _otherId, text);
    _scrollToLatestTimer?.cancel();
    _scrollToLatestTimer = Timer(
      const Duration(milliseconds: 100),
      _scrollToLatest,
    );
  }

  @override
  void dispose() {
    _scrollToLatestTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
