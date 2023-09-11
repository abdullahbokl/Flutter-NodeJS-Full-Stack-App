import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
import '../../manager/register/register_provider.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, registerProvider, child) {
        return CustomButton(
          isLoading: registerProvider.isLoading,
          text: 'Register',
          onTap: () async {
            if (registerProvider.signupFormKey.currentState!.validate()) {
              await registerProvider.register(context);
            }
          },
        );
      },
    );
  }
}
