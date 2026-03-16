import 'package:flutter/material.dart';

import '../../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../../core/theme/app_radius.dart';

class JobsFilterButton extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onTap;

  const JobsFilterButton({
    super.key,
    required this.hasActiveFilters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassPanel(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: hasActiveFilters
                  ? LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.18),
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.tune_rounded,
                  color: hasActiveFilters
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                if (hasActiveFilters)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
