import 'package:flutter/material.dart';

import '../../../../core/common/models/user_model.dart';
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

  UserModel? user;
  final ApiServices _apiServices = getIt<ApiServices>();

  getUserProfile() async {
    final userId = await AppConstants.getCurrentUserId();
    final userData = await _apiServices
        .get(endPoint: "${AppStrings.apiUsersUrl}/$userId")
        .timeout(const Duration(seconds: 10));
    user = UserModel.fromMap(userData);
    if (user != null) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    Logger.logEvent(
        className: 'ProfileProvider', event: 'ProfileProvider disposed');
    super.dispose();
  }
}
