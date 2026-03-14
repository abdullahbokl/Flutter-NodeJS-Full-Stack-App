import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 940),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PremiumSectionHeader(
                  eyebrow: 'Get Started',
                  title: 'Choose the workspace that fits your goal',
                  subtitle: 'A single product, tailored for candidates and hiring teams.',
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 700;
                      final children = [
                        Expanded(
                          child: _RoleCard(
                            title: 'Job Seeker',
                            subtitle: 'Discover jobs, save roles, and track every application with clarity.',
                            icon: Icons.work_outline_rounded,
                            accent: AppColors.primary,
                            onTap: () => context.push('/register/seeker'),
                          ),
                        ),
                        SizedBox(width: wide ? AppSpacing.lg : 0, height: wide ? 0 : AppSpacing.lg),
                        Expanded(
                          child: _RoleCard(
                            title: 'Company',
                            subtitle: 'Post roles, review applicants, and manage hiring momentum in one place.',
                            icon: Icons.apartment_rounded,
                            accent: AppColors.accent,
                            onTap: () => context.push('/register/company'),
                          ),
                        ),
                      ];

                      return wide ? Row(children: children) : Column(children: children);
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Already have an account? Sign in'),
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

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.95),
                  accent.withValues(alpha: 0.55),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Text('Continue', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: accent)),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: accent),
            ],
          ),
        ],
      ),
    );
  }
}
