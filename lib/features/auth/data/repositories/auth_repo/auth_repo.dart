import '../../models/login_model.dart';
import '../../models/register_model.dart';

abstract class AuthRepo {
  Future<dynamic> login({required LoginModel loginModel});

  Future<dynamic> register({required RegisterModel registerModel});

  Future<void> logout();

  Future<void> forgetPassword(String email);
}
