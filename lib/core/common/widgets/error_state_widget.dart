import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../utils/app_colors.dart';
import 'app_button.dart';
import 'premium_ui.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: GlassPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                    label: 'Try Again',
                    onTap: onRetry,
                    width: 180,
                    icon: Icons.refresh_rounded),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
