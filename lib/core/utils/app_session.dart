/// Lightweight runtime session store — no UI imports.
class AppSession {
  AppSession._();

  static String _token = '';
  static String _userId = '';
  static String _role = 'seeker';

  static String get token => _token;
  static String get userId => _userId;
  static String get role => _role;
  static bool get isAuthenticated => _token.isNotEmpty;
  static bool get isCompany => _role == 'company';

  static void setSession({required String token, required String userId, String role = 'seeker'}) {
    _token = token;
    _userId = userId;
    _role = role;
  }

  static void clearSession() {
    _token = '';
    _userId = '';
    _role = 'seeker';
  }
}

