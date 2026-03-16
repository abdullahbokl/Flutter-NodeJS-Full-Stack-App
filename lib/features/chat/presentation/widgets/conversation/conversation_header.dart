import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/app_avatar.dart';
import '../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/app_colors.dart';

class ConversationHeader extends StatelessWidget {
  final String name;
  final VoidCallback onBack;

  const ConversationHeader({
    super.key,
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
              tooltip: 'Back',
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
    );
  }
}
