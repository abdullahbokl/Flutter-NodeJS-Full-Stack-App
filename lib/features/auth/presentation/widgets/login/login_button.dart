import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
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
              await loginProvider.userLogin(context);
            }
          },
          isLoading: loginProvider.isLoading,
        );
      },
    );
  }
}
