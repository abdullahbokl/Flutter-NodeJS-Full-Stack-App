import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_password_icon.dart';
import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../../../../core/utils/data_validation.dart';
import '../../manager/register/register_provider.dart';
import 'register_button.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, registerProvider, child) {
        return AbsorbPointer(
          absorbing: registerProvider.isLoading,
          child: Form(
            key: registerProvider.signupFormKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: registerProvider.userNameController,
                  hintText: 'User Name',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    final errors = DataValidator.validateUserName(value!);
                    if (errors.isNotEmpty) return errors.join('\n');
                    return null;
                  },
                ),
                const HeightSpacer(size: 20),
                CustomTextField(
                  controller: registerProvider.emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final errors = DataValidator.validateEmail(value!);
                    if (errors.isNotEmpty) return errors.join('\n');
                    return null;
                  },
                ),
                const HeightSpacer(size: 20),
                CustomTextField(
                  controller: registerProvider.passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: registerProvider.obscureText,
                  validator: (value) {
                    final errors = DataValidator.validatePassword(value!);
                    if (errors.isNotEmpty) return errors.join('\n');
                    return null;
                  },
                  suffixIcon: GestureDetector(
                      onTap: () {
                        registerProvider.obscureText =
                            !registerProvider.obscureText;
                      },
                      child: CustomPasswordIcon(
                        obscureText: registerProvider.obscureText,
                      )),
                ),
                const HeightSpacer(size: 20),
                CustomTextField(
                  controller: registerProvider.confirmPasswordController,
                  hintText: 'Confirm Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: registerProvider.obscureText,
                  validator: (value) {
                    return value == registerProvider.passwordController.text
                        ? null
                        : 'Password does not match';
                  },
                  suffixIcon: GestureDetector(
                      onTap: () {
                        registerProvider.obscureText =
                            !registerProvider.obscureText;
                      },
                      child: CustomPasswordIcon(
                        obscureText: registerProvider.obscureText,
                      )),
                ),
                const HeightSpacer(size: 50),
                const RegisterButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
