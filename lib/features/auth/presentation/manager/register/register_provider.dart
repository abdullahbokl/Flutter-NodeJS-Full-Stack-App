import 'package:flutter/material.dart';

import '../../../../../core/common/models/user_model.dart';
import '../../../../../core/config/app_setup.dart';
import '../../../../../core/services/logger.dart';
import '../../../data/models/register_model.dart';
import '../../../data/repositories/auth_repo/auth_repo.dart';

class RegisterProvider extends ChangeNotifier {
  // variables
  final _authRepo = getIt<AuthRepo>();
  bool _isObscureText = true;
  bool _firstTime = false;
  bool _isLoading = false;

  // form
  final signupFormKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // getters
  bool get obscureText => _isObscureText;

  bool get firstTime => _firstTime;

  bool get isLoading => _isLoading;

  // setters
  set obscureText(bool value) {
    _isObscureText = value;
    notifyListeners();
  }

  set firstTime(bool newValue) {
    _firstTime = newValue;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

// methods
  register() async {
    if (signupFormKey.currentState!.validate()) {
      try {
        final userJson = await _authRepo.register(
          registerModel: RegisterModel(
            userName: userNameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        if (userJson != null) {
          final UserModel user = UserModel.fromMap(userJson);
          _userRegisterLogger("User registered successfully with id: $user");
        }
      } catch (error) {
        _userRegisterLogger("Error registering user: $error");

        rethrow;
      }
    }
  }

  _userRegisterLogger(String event) {
    Logger.logEvent(
      className: "RegisterProvider",
      event: event,
      methodName: "register",
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
