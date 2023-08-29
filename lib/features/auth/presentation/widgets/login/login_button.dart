import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../manager/login/login_provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return CustomButton(
          text: 'Login',
          onTap: () async {
            if (loginProvider.loginFormKey.currentState!.validate()) {
              loginProvider.isLoading = true;
              try {
                await loginProvider.userLogin();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushReplacementNamed(loginProvider.nextRoute);
                }
              } catch (e) {
                if (context.mounted) {
                  AppConstants.showSnackBar(
                    context: context,
                    message: e.toString(),
                  );
                }
              }
              loginProvider.isLoading = false;
            }
          },
          isLoading: loginProvider.isLoading,
        );
      },
    );
  }
}
