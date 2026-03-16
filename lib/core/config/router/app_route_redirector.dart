import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_session.dart';
import '../service_locator.dart';
import 'app_route_paths.dart';

class AppRouteRedirector {
  const AppRouteRedirector();

  String? redirect(GoRouterState state) {
    final preferences = serviceLocator.isRegistered<SharedPreferences>()
        ? serviceLocator<SharedPreferences>()
        : null;
    final isFirstTime = preferences?.getBool('isFirstTime') ?? true;
    final isLoggedIn = AppSession.isAuthenticated;
    final location = state.matchedLocation;

    if (location == AppRouter.splash) {
      return null;
    }

    if (isLoggedIn) {
      if (location == AppRouter.homePage && AppSession.isCompany) {
        return AppRouter.companyDashboardPage;
      }
      if (location == AppRouter.companyDashboardPage && !AppSession.isCompany) {
        return AppRouter.homePage;
      }
      if (location == AppRouter.onBoarding ||
          location == AppRouter.loginPage ||
          location == AppRouter.roleSelectionPage ||
          location.startsWith('/register/')) {
        return AppSession.isCompany
            ? AppRouter.companyDashboardPage
            : AppRouter.homePage;
      }
      return null;
    }

    if (!isFirstTime && location == AppRouter.onBoarding) {
      return AppRouter.loginPage;
    }

    return null;
  }
}
