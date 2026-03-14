import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_router.dart';
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
      listenWhen: (prev, curr) =>
          curr is MessagesSendError || curr is SuccessState<List<MessageModel>>,
      listener: (ctx, state) {
        if (state is MessagesSendError) {
          AppSnackBars.showError(ctx, 'Failed to send: ${state.errorMessage}');
          return;
        }

        if (state is SuccessState<List<MessageModel>>) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToLatest());
        }
      },
      child: PremiumScaffold(
        child: Column(
          children: [
            _ConversationHeader(
              name: _otherName,
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(
                    AppSession.isCompany
                        ? AppRouter.companyDashboardPage
                        : AppRouter.homePage,
                  );
                }
              },
            ),
            Expanded(
              child: _MessagesList(
                scroll: _scroll,
                otherName: _otherName,
              ),
            ),
            _TypingIndicator(),
            _InputRow(
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
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    context.read<MessagesCubit>().sendMessage(widget.chat.id, _otherId, text);
    Future.delayed(100.ms, _scrollToLatest);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }
}

class _ConversationHeader extends StatelessWidget {
  final String name;
  final VoidCallback onBack;

  const _ConversationHeader({
    required this.name,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            AppAvatar(radius: 22, fallbackInitials: name),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Conversation',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.08);
  }
}

class _MessagesList extends StatelessWidget {
  final ScrollController scroll;
  final String otherName;

  const _MessagesList({
    required this.scroll,
    required this.otherName,
  });

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
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => GlassPanel(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: SingleChildScrollView(
                controller: scroll,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.sm,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (var i = 0; i < msgs.length; i++)
                        Builder(
                          builder: (_) {
                            final msg = msgs[i];
                            final isMine = msg.sender.id == AppSession.userId;
                            final showAvatar = !isMine;
                            return _Bubble(
                              message: msg,
                              isMine: isMine,
                              showAvatar: showAvatar,
                              senderName: otherName,
                            ).animate().fadeIn(delay: Duration(milliseconds: 20 * i));
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;
  final bool showAvatar;
  final String senderName;

  const _Bubble({
    required this.message,
    required this.isMine,
    required this.showAvatar,
    required this.senderName,
  });

  String _formatTime() {
    if (message.createdAt.isEmpty) return '';
    try {
      return DateFormat('HH:mm').format(DateTime.parse(message.createdAt).toLocal());
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.68,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: isMine
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isMine ? null : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.xl),
          topRight: const Radius.circular(AppRadius.xl),
          bottomLeft: Radius.circular(isMine ? AppRadius.xl : AppRadius.sm),
          bottomRight: Radius.circular(isMine ? AppRadius.sm : AppRadius.xl),
        ),
        border: isMine ? null : Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: isMine ? Colors.white : AppColors.textPrimary,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatTime(),
            style: TextStyle(
              color: isMine
                  ? Colors.white.withValues(alpha: 0.72)
                  : AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            AnimatedOpacity(
              duration: 180.ms,
              opacity: showAvatar ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: AppAvatar(
                  radius: 14,
                  fallbackInitials: senderName,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          bubble,
        ],
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
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Row(
                children: [
                  const Text(
                    'typing',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
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
                ],
              ),
            ),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
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
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedContainer(
              duration: 200.ms,
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: _hasText
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      )
                    : null,
                color: _hasText ? null : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: IconButton(
                onPressed: _hasText ? widget.onSend : null,
                icon: Icon(
                  Icons.send_rounded,
                  color: _hasText ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ]),
        ),
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
