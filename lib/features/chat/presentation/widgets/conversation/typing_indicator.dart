import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_colors.dart';

class ConversationTypingIndicator extends StatelessWidget {
  final ValueListenable<bool> typingListenable;

  const ConversationTypingIndicator({
    super.key,
    required this.typingListenable,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: typingListenable,
      builder: (_, isTyping, __) {
        if (!isTyping) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: 4,
          ),
          child: Row(
            children: [
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
                    ...List.generate(
                      3,
                      (index) => Container(
                        key: ValueKey('typing_dot_$index'),
                        margin: const EdgeInsets.only(right: 3),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
