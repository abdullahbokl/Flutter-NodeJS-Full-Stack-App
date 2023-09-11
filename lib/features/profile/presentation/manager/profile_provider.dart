import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/common/models/user_model.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    Logger.logEvent(
        className: 'ProfileProvider', event: 'ProfileProvider created');
  }

  bool _isLoading = false;
  UserModel? user;
  final ApiServices _apiServices = getIt<ApiServices>();

  // getters
  bool get isLoading => _isLoading;

  // setters
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  getUserProfile() async {
    isLoading = true;
    final userId = AppConstants.userId;
    final userData =
        await _apiServices.get(endPoint: "${AppStrings.apiUsersUrl}/$userId");
    user = UserModel.fromMap(userData);
    isLoading = false;
  }

  logout(BuildContext context) {
    AppConstants.userToken = '';
    // Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, AppRouter.loginPage);
    // shared preferences
    final prefs = getIt<SharedPreferences>();
    prefs.remove(AppStrings.userToken);
    // // provider
    Provider.of<ProfileProvider>(context, listen: false).user = null;

    Logger.logEvent(
        className: 'ProfileProvider', event: 'User logged out successfully');
  }

  @override
  void dispose() {
    Logger.logEvent(
        className: 'ProfileProvider', event: 'ProfileProvider disposed');
    super.dispose();
  }
}
