import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../utils/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {

    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary  => (AppColors.primary, Colors.white, Colors.transparent),
      AppButtonVariant.secondary => (AppColors.accent, Colors.white, Colors.transparent),
      AppButtonVariant.outline  => (Colors.transparent, AppColors.primary,  AppColors.primary),
      AppButtonVariant.text     => (Colors.transparent, AppColors.primary,  Colors.transparent),
      AppButtonVariant.danger   => (AppColors.error, Colors.white, Colors.transparent),
    };

    final content = isLoading
        ? SizedBox(
            width: 22, height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg))
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 6)],
              Text(label,
                  style: TextStyle(color: fg, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: AnimatedOpacity(
        opacity: onTap == null && !isLoading ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: border == Colors.transparent ? null
                : Border.all(color: border, width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: isLoading ? null : onTap,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}


