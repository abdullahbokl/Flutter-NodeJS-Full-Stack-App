import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/common/widgets/app_button.dart';
import '../../../core/config/app_setup.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = [
    _OBPage(
      icon: Icons.work_outline_rounded,
      title: 'Find Your Dream Job',
      subtitle: 'Browse thousands of curated job listings tailored to your skills and experience.',
    ),
    _OBPage(
      icon: Icons.person_outline_rounded,
      title: 'Build Your Profile',
      subtitle: 'Showcase your skills, experience, and let employers find you.',
    ),
    _OBPage(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Connect Directly',
      subtitle: 'Chat with hiring agents and get hired faster than ever before.',
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(duration: 350.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    getIt<SharedPreferences>().setBool(AppStrings.prefsIsFirstTime, false);
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.accent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: const Text('Skip',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _PageContent(page: _pages[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _controller,
                      count: _pages.length,
                      effect: const WormEffect(
                        dotColor: Colors.white38,
                        activeDotColor: Colors.white,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 6,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: _page == _pages.length - 1 ? 'Get Started' : 'Next',
                      onTap: _next,
                      variant: AppButtonVariant.secondary,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ],
          ),
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

class _PageContent extends StatelessWidget {
  final _OBPage page;
  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 70, color: Colors.white),
          ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
          const SizedBox(height: AppSpacing.xl),
          Text(page.title,
              style: const TextStyle(
                  color: Colors.white, fontSize: 28,
                  fontWeight: FontWeight.w800, height: 1.2),
              textAlign: TextAlign.center)
              .animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
          const SizedBox(height: AppSpacing.md),
          Text(page.subtitle,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 16, height: 1.5),
              textAlign: TextAlign.center)
              .animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }
}

class _OBPage {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OBPage({required this.icon, required this.title, required this.subtitle});
}


