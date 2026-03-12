import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import '../../features/auth/data/repositories/user_repo/user_repo_impl.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repo_impl.dart';
import '../../features/chat/data/repositories/chat_repo_impl.dart';
import '../../features/jobs/data/repositories/jobs_repo_impl.dart';
import '../../features/search/data/repositories/search_repo_impl.dart';
import '../services/api_services.dart';
import '../services/auth_interceptor.dart';
import '../services/logger.dart';
import '../utils/app_session.dart';
import '../utils/app_strings.dart';
import 'app_config.dart';

final GetIt getIt = GetIt.instance;

class AppSetup {
  static Future<void> setupServiceLocator() async {
    await _registerInfrastructure();
    await _registerRepositories();
    _logEvent("All dependencies registered");
  }

  static Future<void> _registerInfrastructure() async {
    // Shared preferences
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);

    // Dio with AuthInterceptor (no hardcoded token in BaseOptions)
    getIt.registerLazySingleton<Dio>(() {
      return Dio(
        BaseOptions(
          baseUrl: AppConfig.instance.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        ),
      )
        ..interceptors.add(AuthInterceptor())
        ..interceptors.add(LogInterceptor(requestBody: true, responseBody: false));
    });

    getIt.registerLazySingleton<ApiServices>(() => ApiServices(getIt<Dio>()));
  }

  static Future<void> _registerRepositories() async {
    getIt.registerLazySingleton<AuthRepoImpl>(() => AuthRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<UserRepoImpl>(() => UserRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<SearchRepoImpl>(() => SearchRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<JobsRepoImpl>(() => JobsRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<BookmarksRepoImpl>(() => BookmarksRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<ChatRepoImpl>(() => ChatRepoImpl(getIt<ApiServices>()));
  }

  static Future<void> loadData() async {
    _handleUserToken();
    if (AppSession.isAuthenticated) {
      await _handleUserId();
    }
    _logEvent("Session data loaded");
  }

  /// Call on logout — clears session and resets scoped lazy singletons
  static void resetSession() {
    AppSession.clearSession();
    // Repos hold no user-specific state; token cleared in AppSession
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  static void _handleUserToken() {
    final prefs = getIt<SharedPreferences>();
    final saved = prefs.getString(AppStrings.userToken) ?? '';
    if (saved.isNotEmpty && !JwtDecoder.isExpired(saved)) {
      AppSession.setSession(token: saved, userId: '');
    }
  }

  static Future<void> _handleUserId() async {
    try {
      final decoded = JwtDecoder.decode(AppSession.token);
      final id = decoded[AppStrings.userId] as String? ?? '';
      AppSession.setSession(token: AppSession.token, userId: id);
    } catch (_) {
      AppSession.clearSession();
    }
  }

  static void _logEvent(String message) {
    Logger.logEvent(
      className: 'AppSetup',
      event: message,
      methodName: 'setupServiceLocator',
    );
  }
}

