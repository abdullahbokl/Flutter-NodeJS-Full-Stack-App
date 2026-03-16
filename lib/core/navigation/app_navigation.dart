import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../config/router/app_route_paths.dart';
import '../utils/app_session.dart';

class AppNavigation {
  const AppNavigation._();

  static void popOrGoHome(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(
      AppSession.isCompany
          ? AppRouter.companyDashboardPage
          : AppRouter.homePage,
    );
  }
}
