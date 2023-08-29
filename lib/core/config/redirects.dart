import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';
import '../utils/app_strings.dart';
import 'app_router.dart';
import 'app_setup.dart';

class Redirect {
  static String middleware(String routeName) {
    final prefs = getIt<SharedPreferences>();

    if (routeName == AppRouter.onBoarding) {
      routeName = (prefs.getBool(AppStrings.prefsIsFirstTime) ?? true)
          ? AppRouter.onBoarding
          : AppRouter.loginPage;
    }

    if (routeName == AppRouter.loginPage) {
      routeName = (AppConstants.userToken.isEmpty)
          ? AppRouter.loginPage
          : AppRouter.drawer;
    }

    return routeName;
  }
}
