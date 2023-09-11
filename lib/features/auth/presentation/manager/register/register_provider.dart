import 'package:flutter/material.dart';

import '../../../../../core/config/app_setup.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../data/models/register_model.dart';
import '../../../data/repositories/auth_repo/auth_repo_impl.dart';

class RegisterProvider extends ChangeNotifier {
  // variables
  final _authRepo = getIt<AuthRepoImpl>();
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
  register(BuildContext context) async {
    isLoading = true;
    if (signupFormKey.currentState!.validate()) {
      try {
        await _authRepo.register(
          registerModel: RegisterModel(
            userName: userNameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (error) {
        if (context.mounted) {
          AppConstants.showSnackBar(
            context: context,
            message: error.toString(),
          );
        }
      }
    }
    isLoading = false;
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
