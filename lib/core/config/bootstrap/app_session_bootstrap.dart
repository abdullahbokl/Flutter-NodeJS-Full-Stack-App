import 'dart:developer' as developer;

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/logger.dart';
import '../../utils/app_session.dart';

class AppSessionBootstrap {
  const AppSessionBootstrap();

  void restoreCachedSession(SharedPreferences preferences) {
    final savedToken = preferences.getString('token') ?? '';
    if (savedToken.isEmpty || JwtDecoder.isExpired(savedToken)) {
      AppSession.clearSession();
      return;
    }

    final role = preferences.getString('role') ?? 'seeker';
    AppSession.setSession(token: savedToken, userId: '', role: role);
    developer.Timeline.instantSync(
      'session_restored_cached',
      arguments: {'isAuthenticated': true, 'role': role},
    );
    _logEvent('Cached session restored');
  }

  Future<void> hydrateSessionDetails() async {
    if (!AppSession.isAuthenticated || AppSession.userId.isNotEmpty) {
      return;
    }

    try {
      final decoded = JwtDecoder.decode(AppSession.token);
      final userId = decoded['id'] as String? ?? '';
      final role = decoded['role'] as String? ?? AppSession.role;
      AppSession.setSession(
          token: AppSession.token, userId: userId, role: role);
      developer.Timeline.instantSync(
        'session_hydrated',
        arguments: {'userId': userId, 'role': role},
      );
      _logEvent('Session details hydrated');
    } catch (_) {
      AppSession.clearSession();
      _logEvent('Session hydration failed; session cleared');
    }
  }

  void resetSession() {
    AppSession.clearSession();
  }

  void _logEvent(String message) {
    Logger.logEvent(
      className: 'AppSetup',
      event: message,
      methodName: 'bootstrap',
    );
  }
}
