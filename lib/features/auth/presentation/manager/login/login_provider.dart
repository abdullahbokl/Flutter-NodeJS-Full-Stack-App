import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobhub_flutter/features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/common/managers/drawer_provider.dart';
import '../../../../../core/config/app_router.dart';
import '../../../../../core/config/app_setup.dart';
import '../../../../../core/services/logger.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../data/models/login_model.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    Logger.logEvent(
        className: 'LoginProvider', event: 'Provider Created', methodName: '');
  }

  // variables
  final _authRepo = getIt<AuthRepoImpl>();
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
  userLogin(BuildContext context) async {
    isLoading = true;
    try {
      final userJson = await _authRepo.login(
        loginModel: LoginModel(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      if (userJson != null) {
        await _handleToken(userJson[AppStrings.userToken]);
        if (context.mounted) {
          _handleNextRoute(userJson[AppStrings.userFullName], context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: e.toString(),
        );
      }
    }
    isLoading = false;
  }

  _handleToken(String token) async {
    AppConstants.userToken = token;
    await prefs.setString(AppStrings.userToken, token);
    // update the token in the dio header
    getIt<Dio>().options.headers[AppStrings.apiHeadersToken] =
        "Bearer ${AppConstants.userToken}";
  }

  _handleNextRoute(String? fullName, BuildContext context) {
    // if fullName that means user is logging in for the first time
    context.read<DrawerProvider>().currentIndex = 0;

    final nextRoute =
        fullName == null ? AppRouter.editProfilePage : AppRouter.drawer;
    Navigator.of(context).pushReplacementNamed(nextRoute);
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
