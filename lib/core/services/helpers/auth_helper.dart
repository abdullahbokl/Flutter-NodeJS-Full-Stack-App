import 'package:http/http.dart' as https;

import '../../utils/app_strings.dart';

class AuthHelper {
  static var client = https.Client();

  // login using http , ApiConfig.baseUrl

  static Future login(String email, String password) async {
    var response = await client.post(
      Uri.parse(AppStrings.apiLoginUrl),
      body: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }
}
