import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/common/widgets/app_avatar.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;
  final String senderName;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.senderName,
  });

  String _formatTime() {
    if (message.createdAt.isEmpty) {
      return '';
    }

    try {
      return DateFormat('HH:mm')
          .format(DateTime.parse(message.createdAt).toLocal());
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
        color: isMine ? AppColors.primary : AppColors.surfaceElevated,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppRadius.xl),
          topRight: const Radius.circular(AppRadius.xl),
          bottomLeft: Radius.circular(isMine ? AppRadius.xl : AppRadius.sm),
          bottomRight: Radius.circular(isMine ? AppRadius.sm : AppRadius.xl),
        ),
        border: isMine ? null : Border.all(color: AppColors.cardBorder),
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
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: AppAvatar(radius: 14, fallbackInitials: senderName),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          bubble,
        ],
      ),
    );
  }
}
