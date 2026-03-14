import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../utils/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final List<BoxShadow>? shadows;
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
    this.borderRadius,
    this.onTap,
    this.width,
    this.border,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.surfaceDark : AppColors.surfaceElevated);
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.xl);
    final content = onTap != null
        ? Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap, borderRadius: radius, child: _padded()),
          )
        : _padded();

    return SizedBox(
      width: width,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: cardColor,
          gradient: gradient,
          borderRadius: radius,
          boxShadow: shadows ?? AppShadows.md,
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
