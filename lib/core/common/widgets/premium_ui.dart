import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';
import '../../theme/app_spacing.dart';
import '../../utils/app_colors.dart';
import 'app_button.dart';
import 'app_card.dart';

class PremiumScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const PremiumScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.pageGlow),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: _GlowOrb(
                size: 240,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              top: 180,
              left: -70,
              child: _GlowOrb(
                size: 190,
                color: AppColors.accent.withValues(alpha: 0.12),
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.xl);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AppCard(
          onTap: onTap,
          padding: padding,
          borderRadius: radius,
          color: Colors.white.withValues(alpha: 0.74),
          border: Border.all(color: AppColors.glassStroke.withValues(alpha: 0.35)),
          shadows: AppShadows.lg,
          child: child,
        ),
      ),
    );
  }
}

class PremiumSectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;
  final String? actionTooltip;

  const PremiumSectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.actionTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 6),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
        ),
        if (actionIcon != null)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onAction,
              tooltip: actionTooltip,
              icon: Icon(actionIcon, size: 20),
            ),
          )
        else if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

enum PageHeaderActionStyle { icon, text }

enum PageHeaderDensity { standard, compact }

class PageHeaderAction {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? label;
  final String? tooltip;
  final PageHeaderActionStyle style;

  const PageHeaderAction.icon({
    required this.onPressed,
    required this.icon,
    this.tooltip,
  })  : label = null,
        style = PageHeaderActionStyle.icon;

  const PageHeaderAction.text({
    required this.onPressed,
    required this.label,
    this.tooltip,
  })  : icon = null,
        style = PageHeaderActionStyle.text;
}

class PageHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final String? subtitle;
  final PageHeaderAction? leadingAction;
  final List<PageHeaderAction> actions;
  final PageHeaderDensity density;

  const PageHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.leadingAction,
    this.actions = const [],
    this.density = PageHeaderDensity.standard,
  });

  @override
  Widget build(BuildContext context) {
    final titleChildren = <Widget>[
      if (eyebrow?.trim().isNotEmpty == true) ...[
        Text(
          eyebrow!.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
        ),
        SizedBox(height: density == PageHeaderDensity.compact ? 4 : 6),
      ],
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      if (subtitle?.trim().isNotEmpty == true) ...[
        const SizedBox(height: 4),
        Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingAction != null) ...[
          _PageHeaderActionButton(action: leadingAction!),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: titleChildren,
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                _PageHeaderActionButton(action: actions[i]),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _PageHeaderActionButton extends StatelessWidget {
  final PageHeaderAction action;

  const _PageHeaderActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return switch (action.style) {
      PageHeaderActionStyle.icon => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: action.onPressed,
            tooltip: action.tooltip,
            icon: Icon(action.icon, size: 20),
          ),
        ),
      PageHeaderActionStyle.text => TextButton(
          onPressed: action.onPressed,
          child: Text(action.label!),
        ),
    };
  }
}

class PremiumSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PremiumSearchBar({
    super.key,
    required this.hint,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      onTap: onTap,
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textHint),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class PremiumStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? caption;
  final VoidCallback? onTap;

  const PremiumStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.caption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (caption != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    caption!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: color.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

class ApplicationStatusStepper extends StatelessWidget {
  final String status;

  const ApplicationStatusStepper({
    super.key,
    required this.status,
  });

  static const List<(String, String)> _steps = [
    ('applied', 'Applied'),
    ('under_review', 'Review'),
    ('interview', 'Interview'),
    ('accepted', 'Decision'),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = _steps.indexWhere((step) => step.$1 == status).clamp(0, _steps.length - 1);

    return Row(
      children: List.generate(_steps.length, (index) {
        final isActive = index <= activeIndex;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.divider,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _steps[index].$2,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isActive ? AppColors.primary : AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (index != _steps.length - 1) const SizedBox(width: AppSpacing.xs),
            ],
          ),
        );
      }),
    );
  }
}

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isApple = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Google',
            variant: AppButtonVariant.soft,
            icon: Icons.g_mobiledata_rounded,
            onTap: () {},
          ),
        ),
        if (isApple) ...[
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppButton(
              label: 'Apple',
              variant: AppButtonVariant.soft,
              icon: Icons.apple_rounded,
              onTap: () {},
            ),
          ),
        ],
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
