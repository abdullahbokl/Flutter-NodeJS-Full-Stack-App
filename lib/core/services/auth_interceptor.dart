import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_session.dart';
import '../utils/app_strings.dart';

/// Intercepts every request to inject the Bearer token.
/// On 401, attempts to logout gracefully (token refresh not yet supported server-side).
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppSession.token;
    if (token.isNotEmpty) {
      options.headers[AppStrings.apiHeadersToken] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Clear stale session and let the router redirect to login
      AppSession.clearSession();
      final prefs = GetIt.instance<SharedPreferences>();
      await prefs.remove(AppStrings.userToken);
    }
    handler.next(err);
  }
}

