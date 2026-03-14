import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1600), _goNext);
  }

  void _goNext() {
    final prefs = getIt<SharedPreferences>();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (AppSession.isAuthenticated) {
      context.go(AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage);
      return;
    }

    context.go(isFirstTime ? AppRouter.onBoarding : AppRouter.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: _Orb(color: AppColors.accent.withValues(alpha: 0.22), size: 220),
            ),
            Positioned(
              bottom: -100,
              left: -40,
              child: _Orb(color: Colors.white.withValues(alpha: 0.12), size: 260),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.xxl),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: const Icon(Icons.work_outline_rounded, color: Colors.white, size: 54),
                    ).animate().scale(duration: 500.ms).fadeIn(),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Job Hub',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
                    ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.25),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Hire faster. Apply smarter.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                          ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: 120,
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        color: AppColors.accent,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                      ),
                    ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class _Orb extends StatelessWidget {
  final Color color;
  final double size;

  const _Orb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }
}
