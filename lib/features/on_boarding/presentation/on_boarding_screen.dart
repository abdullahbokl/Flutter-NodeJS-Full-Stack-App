import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/common/widgets/app_button.dart';
import '../../../core/common/widgets/app_card.dart';
import '../../../core/common/widgets/premium_ui.dart';
import '../../../core/config/app_router.dart';
import '../../../core/config/app_setup.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardingData(
      title: 'Discover roles that feel curated for you',
      subtitle: 'Search, shortlist, and compare opportunities in a cleaner way.',
      icon: Icons.travel_explore_rounded,
      accent: AppColors.accent,
    ),
    _OnboardingData(
      title: 'Build one profile that opens more doors',
      subtitle: 'Showcase your skills, experience, and story with a sharper first impression.',
      icon: Icons.badge_outlined,
      accent: AppColors.primary,
    ),
    _OnboardingData(
      title: 'Track every application with clarity',
      subtitle: 'Stay on top of review stages, interviews, and hiring conversations.',
      icon: Icons.track_changes_rounded,
      accent: AppColors.info,
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(duration: 360.ms, curve: Curves.easeOutCubic);
      return;
    }
    _finish();
  }

  void _finish() {
    getIt<SharedPreferences>().setBool('isFirstTime', false);
    context.go(AppRouter.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                GlassPanel(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.work_outline_rounded, size: 18, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Job Hub', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: _finish, child: const Text('Skip')),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _page = value),
                itemCount: _pages.length,
                itemBuilder: (_, index) => _OnboardingPage(data: _pages[index]),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    dotColor: AppColors.divider,
                    activeDotColor: AppColors.primary,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: AppButton(
                    label: _page == _pages.length - 1 ? 'Continue' : 'Next',
                    icon: Icons.arrow_forward_rounded,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 720;

        final illustration = GlassPanel(
          padding: const EdgeInsets.all(AppSpacing.lg),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: AspectRatio(
            aspectRatio: wide ? 1.15 : 0.95,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          data.accent.withValues(alpha: 0.22),
                          AppColors.primary.withValues(alpha: 0.08),
                          Colors.white,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                  ),
                ),
                const Positioned(
                  top: 18,
                  left: 18,
                  child: _MiniCard(
                    label: 'Premium Match',
                    icon: Icons.bolt_rounded,
                    color: AppColors.accent,
                  ),
                ),
                const Positioned(
                  top: 70,
                  right: 24,
                  child: _MetricBubble(
                    title: '24h',
                    subtitle: 'Avg. response',
                    color: AppColors.primary,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          data.accent,
                          AppColors.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Icon(data.icon, size: 58, color: Colors.white),
                  ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
                ),
                Positioned(
                  left: 18,
                  right: 18,
                  bottom: 18,
                  child: AppCard(
                    color: Colors.white.withValues(alpha: 0.82),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Designed for modern hiring', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'A polished workflow for seekers and companies, without changing the core logic underneath.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A refined hiring experience',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(data.title, style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: AppSpacing.md),
            Text(data.subtitle, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ).animate().fadeIn().slideY(begin: 0.08);

        if (wide) {
          return Row(
            children: [
              Expanded(flex: 6, child: illustration),
              const SizedBox(width: AppSpacing.xl),
              Expanded(flex: 5, child: copy),
            ],
          );
        }

        return Column(
          children: [
            Expanded(child: illustration),
            const SizedBox(height: AppSpacing.lg),
            copy,
          ],
        );
      },
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _MiniCard({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
      color: Colors.white.withValues(alpha: 0.84),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _MetricBubble extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _MetricBubble({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: Colors.white.withValues(alpha: 0.88),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
          Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });
}
