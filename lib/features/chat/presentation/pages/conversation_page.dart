import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../bloc/messages_cubit.dart';

class ConversationPage extends StatelessWidget {
  final ChatModel? chat;
  const ConversationPage({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    if (chat == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Chat not found')));
    }
    return BlocProvider(
      create: (_) => getIt<MessagesCubit>()
        ..loadMessages(chat!.id)
        ..connectSocket(chat!.id),
      child: _ConversationView(chat: chat!),
    );
  }
}

class _ConversationView extends StatefulWidget {
  final ChatModel chat;
  const _ConversationView({required this.chat});
  @override
  State<_ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<_ConversationView> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  String get _otherId {
    final other = widget.chat.users.firstWhere(
      (u) => u.id != AppSession.userId,
      orElse: () => widget.chat.users.first,
    );
    return other.id;
  }

  String get _otherName {
    final other = widget.chat.users.firstWhere(
      (u) => u.id != AppSession.userId,
      orElse: () => widget.chat.users.first,
    );
    return other.fullName ?? other.userName;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagesCubit, BaseState<List<MessageModel>>>(
      listenWhen: (_, curr) => curr is MessagesSendError,
      listener: (ctx, state) {
        if (state is MessagesSendError) {
          AppSnackBars.showError(ctx, 'Failed to send: ${state.errorMessage}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop()),
          title: Row(children: [
            AppAvatar(radius: 18, fallbackInitials: _otherName),
            const SizedBox(width: AppSpacing.sm),
            Text(_otherName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
        ),
        body: Column(children: [
          Expanded(child: _MessagesList(scroll: _scroll)),
          _TypingIndicator(),
          _InputRow(controller: _controller, chatId: widget.chat.id, onSend: _send),
        ]),
      ),
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<MessagesCubit>().sendMessage(widget.chat.id, _otherId, text);
    Future.delayed(100.ms, () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: 300.ms, curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }
}

class _MessagesList extends StatelessWidget {
  final ScrollController scroll;
  const _MessagesList({required this.scroll});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, BaseState<List<MessageModel>>>(
      builder: (ctx, state) {
        if (state is LoadingState<List<MessageModel>> ||
            state is InitialState<List<MessageModel>>) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (state is ErrorState<List<MessageModel>>) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is EmptyState<List<MessageModel>>) {
          return const Center(
            child: Text(
              'No messages yet. Start the conversation.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        final msgs = (state as SuccessState<List<MessageModel>>).data;
        return ListView.builder(
          controller: scroll,
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: msgs.length,
          itemBuilder: (_, i) {
            final msg = msgs[i];
            final isMine = msg.sender.id == AppSession.userId;
            return _Bubble(message: msg, isMine: isMine)
                .animate().fadeIn(delay: Duration(milliseconds: 20 * i));
          },
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;
  const _Bubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.xl),
            topRight: const Radius.circular(AppRadius.xl),
            bottomLeft: Radius.circular(isMine ? AppRadius.xl : AppRadius.sm),
            bottomRight: Radius.circular(isMine ? AppRadius.sm : AppRadius.xl),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Text(message.content,
            style: TextStyle(
                color: isMine ? Colors.white : AppColors.textPrimary,
                fontSize: 14)),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, BaseState<List<MessageModel>>>(
      buildWhen: (prev, _) => true,
      builder: (ctx, _) {
        final cubit = ctx.read<MessagesCubit>();
        if (!cubit.isTyping) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 4),
          child: Row(children: [
            const Text('typing',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(width: 4),
            ...List.generate(3, (i) => Container(
              margin: const EdgeInsets.only(right: 3),
              width: 6, height: 6,
              decoration: const BoxDecoration(
                  color: AppColors.textSecondary, shape: BoxShape.circle),
            ).animate(onPlay: (c) => c.repeat())
              .moveY(begin: 0, end: -4, delay: Duration(milliseconds: 100 * i),
                    duration: 300.ms, curve: Curves.easeInOut)
              .then().moveY(begin: -4, end: 0, duration: 300.ms)),
          ]),
        );
      },
    );
  }
}

class _InputRow extends StatefulWidget {
  final TextEditingController controller;
  final String chatId;
  final VoidCallback onSend;
  const _InputRow({
    required this.controller,
    required this.chatId,
    required this.onSend,
  });
  @override
  State<_InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<_InputRow> {
  bool _hasText = false;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      final hasText = widget.controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        if (hasText) {
          context.read<MessagesCubit>().emitTyping(widget.chatId);
        } else {
          context.read<MessagesCubit>().emitStopTyping(widget.chatId);
        }
      }
      setState(() => _hasText = hasText);
    };
    widget.controller.addListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => widget.onSend(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    borderSide: BorderSide.none),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: 200.ms,
            child: IconButton(
              onPressed: _hasText ? widget.onSend : null,
              icon: Icon(Icons.send_rounded,
                  color: _hasText ? AppColors.primary : AppColors.textSecondary),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    if (_hasText) {
      context.read<MessagesCubit>().emitStopTyping(widget.chatId);
    }
    widget.controller.removeListener(_listener);
    super.dispose();
  }
}
