import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../utils/app_colors.dart';

enum AppCardShadowLevel { none, sm, md }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final List<BoxShadow>? shadows;
  final AppCardShadowLevel shadowLevel;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double? width;
  final Border? border;
  final Gradient? gradient;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.shadows,
    this.shadowLevel = AppCardShadowLevel.sm,
    this.borderRadius,
    this.onTap,
    this.width,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        color ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceElevated);
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.xl);
    final resolvedShadows = shadows ??
        switch (shadowLevel) {
          AppCardShadowLevel.none => null,
          AppCardShadowLevel.sm => AppShadows.sm,
          AppCardShadowLevel.md => AppShadows.md,
        };
    final content = onTap != null
        ? Material(
            color: Colors.transparent,
            child:
                InkWell(onTap: onTap, borderRadius: radius, child: _padded()),
          )
        : _padded();

    return SizedBox(
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cardColor,
          gradient: gradient,
          borderRadius: radius,
          boxShadow: resolvedShadows,
          border: border ??
              Border.all(
                color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
              ),
        ),
        child: content,
      ),
    );
  }

  Widget _padded() =>
      Padding(padding: padding ?? const EdgeInsets.all(16), child: child);
}
