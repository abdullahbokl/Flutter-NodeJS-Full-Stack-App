import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_strings.dart';

class OnBoardingProvider extends ChangeNotifier {
  OnBoardingProvider() {
    Logger.logEvent(className: 'OnBoardingProvider', event: 'Provider Created');
  }

  final PageController pageController = PageController(initialPage: 0);
  final prefs = getIt<SharedPreferences>();

  bool _isLastPage = false;

  bool get isLastPage => _isLastPage;

  set isLastPage(bool lastPage) {
    _isLastPage = lastPage;
    notifyListeners();
  }

  setIsFirstTime() {
    prefs.setBool(AppStrings.prefsIsFirstTime, false);
  }

  @override
  Future<void> dispose() async {
    pageController.dispose();
    setIsFirstTime();
    Logger.logEvent(
      className: 'OnBoardingProvider',
      event: 'Provider Disposed',
      methodName: 'dispose',
    );
    super.dispose();
  }
}
