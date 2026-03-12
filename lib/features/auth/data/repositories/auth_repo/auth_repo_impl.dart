import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/app_setup.dart';
import '../../../../../core/errors/server_error_handler.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/logger.dart';
import '../../../../../core/utils/app_session.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiServices _apiServices;

  AuthRepoImpl(this._apiServices);

  @override
  Future<dynamic> register({required RegisterModel registerModel}) async {
    try {
      final user = await _apiServices.post(
        endPoint: AppStrings.apiRegisterUrl,
        data: registerModel.toMap(),
      );
      _registerLogger("User registered successfully");
      return user;
    } catch (e) {
      _registerLogger(handleServerError(e));
      throw handleServerError(e);
    }
  }

  @override
  Future<dynamic> login({required LoginModel loginModel}) async {
    try {
      final user = await _apiServices.post(
        endPoint: AppStrings.apiLoginUrl,
        data: loginModel.toMap(),
      );
      _loginLogger("User logged in successfully");
      return user;
    } catch (e) {
      _loginLogger(handleServerError(e));
      throw handleServerError(e);
    }
  }

  @override
  Future<void> logout() async {
    AppSession.clearSession();
    final prefs = getIt<SharedPreferences>();
    await prefs.remove(AppStrings.userToken);
    _loginLogger("User logged out");
  }

  @override
  Future<void> forgetPassword(String email) {
    // TODO: implement when backend supports password reset endpoint
    throw UnimplementedError('forgetPassword not yet supported by the backend');
  }

  void _registerLogger(String event) {
    Logger.logEvent(
      className: "AuthRepositoryImpl",
      event: event,
      methodName: "register",
    );
  }

  void _loginLogger(String event) {
    Logger.logEvent(
      className: "AuthRepositoryImpl",
      event: event,
      methodName: "login",
    );
  }
}


