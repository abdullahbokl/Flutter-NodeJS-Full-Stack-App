import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jobhub_flutter/features/jobs/data/repositories/jobs_repo_impl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import '../../features/auth/data/repositories/user_repo/user_repo_impl.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repo_impl.dart';
import '../../features/search/data/repositories/search_repo_impl.dart';
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
    getIt.registerLazySingleton<AuthRepositoryImpl>(
        () => AuthRepositoryImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<UserRepoImpl>(
        () => UserRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<SearchRepoImpl>(
        () => SearchRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<JobsRepoImpl>(
        () => JobsRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<BookmarksRepoImpl>(
        () => BookmarksRepoImpl(getIt<ApiServices>()));

    await getIt.allReady().then((_) {
      _logEvent("All dependencies are ready");
    }).catchError((e) {
      _logEvent("Error");
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

_logEvent(String message) {
  return Logger.logEvent(
    className: "ServiceLocator",
    event: message,
    methodName: "setupServiceLocator",
  );
}
