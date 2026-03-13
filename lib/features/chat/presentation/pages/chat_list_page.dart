import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<ChatCubit>().loadChats(),
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, BaseState<List<ChatModel>>>(
        builder: (ctx, state) => BlocStateWidget<List<ChatModel>>(
          state: state,
          emptyTitle: 'No conversations yet',
          emptySubtitle: 'Start chatting with hiring agents',
          emptyIcon: Icons.chat_bubble_outline_rounded,
          onRetry: () => ctx.read<ChatCubit>().loadChats(),
          onSuccess: (chats) => ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 80),
            itemBuilder: (_, i) => _ChatTile(chat: chats[i])
                .animate().fadeIn(delay: Duration(milliseconds: 40 * i)),
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
    // Get the other participant (not current user)
    final other = chat.users.firstWhere(
      (u) => u.id != AppSession.userId,
      orElse: () => chat.users.isNotEmpty ? chat.users.first : chat.users.first,
    );

    final lastMsg = chat.latestMessage?.content ?? '';
    final lastTime = chat.latestMessage?.createdAt;
    String timeStr = '';
    if (lastTime != null) {
      try {
        final dt = DateTime.parse(lastTime);
        final now = DateTime.now();
        timeStr = now.difference(dt).inDays > 0
            ? DateFormat('MMM d').format(dt)
            : DateFormat('HH:mm').format(dt);
      } catch (_) {}
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      onTap: () => context.push('/chat/${chat.id}', extra: chat),
      leading: AppAvatar(
        imageUrl: other.profilePic.lastOrNull,
        radius: 26,
        fallbackInitials: other.fullName ?? other.userName,
        showOnlineDot: false,
      ),
      title: Text(other.fullName ?? other.userName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(lastMsg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      trailing: timeStr.isNotEmpty
          ? Text(timeStr,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))
          : null,
    );
  }
}

