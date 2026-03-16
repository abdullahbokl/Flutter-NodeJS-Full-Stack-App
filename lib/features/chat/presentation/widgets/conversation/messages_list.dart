import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/base_state.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_session.dart';
import '../../../data/models/message_model.dart';
import '../../bloc/messages_cubit.dart';
import 'components/message_bubble.dart';

class MessagesList extends StatelessWidget {
  final ScrollController scrollController;
  final String otherName;

  const MessagesList({
    super.key,
    required this.scrollController,
    required this.otherName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagesCubit, BaseState<List<MessageModel>>>(
      builder: (_, state) {
        if (state is LoadingState<List<MessageModel>> ||
            state is InitialState<List<MessageModel>>) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
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

        final messages = (state as SuccessState<List<MessageModel>>).data;
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: ListView.builder(
            controller: scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[messages.length - 1 - index];
              final isMine = message.sender.id == AppSession.userId;
              return RepaintBoundary(
                child: MessageBubble(
                  key: ValueKey(message.id),
                  message: message,
                  isMine: isMine,
                  senderName: otherName,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
