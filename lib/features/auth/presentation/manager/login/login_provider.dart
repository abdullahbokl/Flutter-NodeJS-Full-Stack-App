import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/app_router.dart';
import '../../../../../core/config/app_setup.dart';
import '../../../../../core/services/logger.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../data/models/login_model.dart';
import '../../../data/repositories/auth_repo/auth_repo.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    Logger.logEvent(
        className: 'LoginProvider', event: 'Provider Created', methodName: '');
  }

  // variables
  final _authRepo = getIt<AuthRepo>();
  final prefs = getIt<SharedPreferences>();
  String _nextRoute = AppRouter.drawer;
  bool _isObscureText = true;
  bool _isLoading = false;

  // form
  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // getters
  String get nextRoute => _nextRoute;

  bool get obscureText => _isObscureText;

  bool get isLoading => _isLoading;

  // setters
  set obscureText(bool value) {
    _isObscureText = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // methods
  userLogin() async {
    try {
      final userJson = await _authRepo.login(
        loginModel: LoginModel(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      if (userJson != null) {
        await _handleToken(userJson[AppStrings.userToken]);
        _handleNextRoute(userJson[AppStrings.userFullName]);
      }
    } catch (e) {
      rethrow;
    }
  }

  _handleToken(String token) async {
    AppConstants.userToken = token;
    await prefs.setString(AppStrings.userToken, token);
  }

  _handleNextRoute(String? fullName) {
    // if fullName that means user is logging in for the first time
    _nextRoute = fullName == null ? AppRouter.editProfile : AppRouter.drawer;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    Logger.logEvent(
        className: 'LoginProvider',
        event: 'Provider Disposed',
        methodName: 'dispose');
    super.dispose();
  }
}
