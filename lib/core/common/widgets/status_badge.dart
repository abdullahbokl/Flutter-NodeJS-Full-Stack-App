import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../utils/app_colors.dart';

enum BadgeVariant { success, warning, error, info, neutral }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final bool isCircular;

  const StatusBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.neutral,
    this.isCircular = false,
  });

  factory StatusBadge.contract(String contract) {
    final v = switch (contract.toLowerCase()) {
      'full-time'  => BadgeVariant.success,
      'part-time'  => BadgeVariant.warning,
      'freelance'  => BadgeVariant.info,
      'remote'     => BadgeVariant.neutral,
      _            => BadgeVariant.neutral,
    };
    return StatusBadge(label: contract, variant: v);
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (variant) {
      BadgeVariant.success => (AppColors.success.withOpacity(0.12), AppColors.success),
      BadgeVariant.warning => (AppColors.warning.withOpacity(0.12), AppColors.warning),
      BadgeVariant.error   => (AppColors.error.withOpacity(0.12),   AppColors.error),
      BadgeVariant.info    => (AppColors.info.withOpacity(0.12),    AppColors.info),
      BadgeVariant.neutral => (AppColors.primary.withOpacity(0.10), AppColors.primary),
    };

    if (isCircular) {
      return Container(
        width: 22, height: 22,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Center(
          child: Text(label,
              style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

