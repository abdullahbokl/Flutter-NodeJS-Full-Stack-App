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
      child: LayoutBuilder(
        builder: (context, viewportConstraints) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 940,
                minHeight: viewportConstraints.maxHeight - (AppSpacing.lg * 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PremiumSectionHeader(
                    eyebrow: 'Get Started',
                    title: 'Choose the workspace that fits your goal',
                    subtitle:
                        'A single product, tailored for candidates and hiring teams.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 700;
                      final cards = [
                        _RoleCard(
                          title: 'Job Seeker',
                          subtitle:
                              'Discover jobs, save roles, and track every application with clarity.',
                          icon: Icons.work_outline_rounded,
                          accent: AppColors.primary,
                          onTap: () => context.push('/register/seeker'),
                        ),
                        _RoleCard(
                          title: 'Company',
                          subtitle:
                              'Post roles, review applicants, and manage hiring momentum in one place.',
                          icon: Icons.apartment_rounded,
                          accent: AppColors.accent,
                          onTap: () => context.push('/register/company'),
                        ),
                      ];

                      if (wide) {
                        return SizedBox(
                          height: 312,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: cards[0]),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(child: cards[1]),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          cards[0],
                          const SizedBox(height: AppSpacing.lg),
                          cards[1],
                        ],
                      );
                    },
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 280),
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
            const SizedBox(height: AppSpacing.xl),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            Row(
              children: [
                Text('Continue',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: accent)),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, color: accent),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
