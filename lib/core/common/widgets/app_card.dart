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

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.shadows,
    this.borderRadius,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.surfaceDark : AppColors.surface);
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.xl);

    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: radius,
          boxShadow: shadows ?? AppShadows.md,
        ),
        child: onTap != null
            ? InkWell(onTap: onTap, borderRadius: radius, child: _padded())
            : _padded(),
      ),
    );
  }

  Widget _padded() =>
      Padding(padding: padding ?? const EdgeInsets.all(16), child: child);
}

