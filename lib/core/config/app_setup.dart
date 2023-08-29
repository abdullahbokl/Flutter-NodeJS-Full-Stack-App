import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repo/auth_repo.dart';
import '../../features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import '../../features/auth/data/repositories/user_repo/user_repo.dart';
import '../../features/auth/data/repositories/user_repo/user_repo_impl.dart';
import '../services/api_services.dart';
import '../services/logger.dart';
import '../utils/app_constants.dart';
import '../utils/app_strings.dart';

GetIt getIt = GetIt.instance;

class AppSetup {
  static Future<void> setupServiceLocator() async {
    // shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    // API
    getIt.registerLazySingleton<Dio>(() => Dio());
    getIt.registerLazySingleton<ApiServices>(() => ApiServices(getIt<Dio>()));

    // repositories
    getIt.registerLazySingleton<AuthRepo>(
        () => AuthRepositoryImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<UserRepo>(
        () => UserRepoImpl(getIt<ApiServices>()));

    await getIt.allReady().then((_) {
      debugPrint("All dependencies are ready");
    }).catchError((e) {
      Logger.logEvent(
        className: "ServiceLocator",
        event: "Error",
        methodName: "setupServiceLocator",
      );
    });
  }

  static loadData() async {
    // final prefs = getIt<SharedPreferences>();
    // prefs.remove(AppStrings.userToken);
    // prefs.clear();
    _handleUserToken();

    Logger.logEvent(
      className: "",
      event: "Data Loaded",
      methodName: "loadData",
    );
  }
}

_handleUserToken() async {
  final prefs = getIt<SharedPreferences>();
  AppConstants.userToken = prefs.getString(AppStrings.userToken) ?? "";
  if (AppConstants.userToken.isNotEmpty) {
    final isExpired = JwtDecoder.isExpired(AppConstants.userToken);
    if (isExpired) {
      AppConstants.userToken = "";
    }
  }
}
