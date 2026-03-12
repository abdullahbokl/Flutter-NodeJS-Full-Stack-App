/// Lightweight runtime session store — no UI imports.
class AppSession {
  AppSession._();

  static String _token = '';
  static String _userId = '';

  static String get token => _token;
  static String get userId => _userId;
  static bool get isAuthenticated => _token.isNotEmpty;

  static void setSession({required String token, required String userId}) {
    _token = token;
    _userId = userId;
  }

  static void clearSession() {
    _token = '';
    _userId = '';
  }
}

