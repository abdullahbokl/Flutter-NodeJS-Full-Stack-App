import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_session.dart';
import '../../data/models/chat_model.dart';
import '../bloc/chat_cubit.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatCubit>()..loadChats(),
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(
      AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: BlocBuilder<ChatCubit, BaseState<List<ChatModel>>>(
        builder: (context, state) => BlocStateWidget<List<ChatModel>>(
          state: state,
          emptyTitle: 'No conversations yet',
          emptySubtitle: 'Once you apply or connect with someone, messages will appear here.',
          emptyIcon: Icons.chat_bubble_outline_rounded,
          onRetry: () => context.read<ChatCubit>().loadChats(),
          onSuccess: (chats) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: chats.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              if (index == 0) {
                return PageHeader(
                  eyebrow: 'Inbox',
                  title: 'Messages',
                  subtitle: 'Keep hiring conversations and job follow-ups organized.',
                  leadingAction: PageHeaderAction.icon(
                    onPressed: () => _handleBack(context),
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                  ),
                  actions: [
                    PageHeaderAction.text(
                      onPressed: () => context.push(AppRouter.myApplicationsPage),
                      label: 'Applications',
                    ),
                  ],
                );
              }

              final chat = chats[index - 1];
              return _ChatTile(chat: chat);
            },
          ),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    final other = chat.users.firstWhere(
      (u) => u.id != AppSession.userId,
      orElse: () => chat.users.isNotEmpty ? chat.users.first : chat.users.first,
    );

    final lastMsg = chat.latestMessage?.content ?? 'Tap to open the conversation';
    final lastTime = chat.latestMessage?.createdAt;
    String timeStr = '';
    if (lastTime != null) {
      try {
        final dt = DateTime.parse(lastTime);
        final now = DateTime.now();
        timeStr = now.difference(dt).inDays > 0 ? DateFormat('MMM d').format(dt) : DateFormat('HH:mm').format(dt);
      } catch (_) {}
    }

    return AppCard(
      onTap: () => context.push('/chat/${chat.id}', extra: chat),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: other.profilePic.lastOrNull,
            radius: 24,
            fallbackInitials: other.fullName ?? other.userName,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(other.fullName ?? other.userName, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  lastMsg,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(timeStr, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
