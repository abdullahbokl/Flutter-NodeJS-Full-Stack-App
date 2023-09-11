import '../../../../../core/errors/server_error_handler.dart';
import '../../../../../core/services/api_services.dart';
import '../../../../../core/services/logger.dart';
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
  Future<void> forgetPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  _registerLogger(String event) {
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
