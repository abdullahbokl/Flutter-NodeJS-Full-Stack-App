import 'package:go_router/go_router.dart';

import '../../../../features/auth/domain/entities/user_role.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../features/auth/presentation/pages/register_page.dart';
import '../../../../features/auth/presentation/pages/role_selection_page.dart';
import '../../../../features/on_boarding/presentation/on_boarding_screen.dart';
import '../../../../features/splash/presentation/pages/splash_page.dart';
import '../app_route_paths.dart';

List<RouteBase> buildAuthRoutes() {
  return [
    GoRoute(
      path: AppRouter.splash,
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: AppRouter.onBoarding,
      builder: (_, __) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRouter.loginPage,
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: AppRouter.roleSelectionPage,
      builder: (_, __) => const RoleSelectionPage(),
    ),
    GoRoute(
      path: AppRouter.registerPage,
      builder: (_, state) {
        final role =
            UserRole.fromString(state.pathParameters['role'] ?? 'seeker');
        return RegisterPage(role: role);
      },
    ),
  ];
}
