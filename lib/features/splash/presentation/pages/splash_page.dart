import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _bootstrapAndNavigate();
    });
  }

  Future<void> _bootstrapAndNavigate() async {
    try {
      await AppSetup.completeDeferredBootstrap();
      if (!mounted) return;
      _goNext();
    } catch (_) {
      AppSetup.bootstrapReadiness.value = AppBootstrapReadiness.failed;
    }
  }

  void _goNext() {
    final prefs = getIt<SharedPreferences>();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (AppSession.isAuthenticated) {
      context.go(AppSession.isCompany
          ? AppRouter.companyDashboardPage
          : AppRouter.homePage);
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
              child: _Orb(
                  color: AppColors.accent.withValues(alpha: 0.22), size: 220),
            ),
            Positioned(
              bottom: -100,
              left: -40,
              child:
                  _Orb(color: Colors.white.withValues(alpha: 0.12), size: 260),
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
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22)),
                      ),
                      child: const Icon(
                        Icons.work_outline_rounded,
                        color: Colors.white,
                        size: 54,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Job Hub',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ValueListenableBuilder<AppBootstrapReadiness>(
                      valueListenable: AppSetup.bootstrapReadiness,
                      builder: (context, readiness, _) {
                        final subtitle = switch (readiness) {
                          AppBootstrapReadiness.failed =>
                            'We hit a startup issue. Tap retry to continue.',
                          AppBootstrapReadiness.ready =>
                            'Preparing your next screen.',
                          _ => 'Loading your workspace as fast as possible.',
                        };

                        return Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.78),
                                  ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ValueListenableBuilder<AppBootstrapReadiness>(
                      valueListenable: AppSetup.bootstrapReadiness,
                      builder: (context, readiness, _) {
                        if (readiness == AppBootstrapReadiness.failed) {
                          return FilledButton(
                            onPressed: _bootstrapAndNavigate,
                            child: const Text('Retry startup'),
                          );
                        }

                        return SizedBox(
                          width: 132,
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.16),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accent,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
