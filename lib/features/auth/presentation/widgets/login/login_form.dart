import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/custom_password_icon.dart';
import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/data_validation.dart';
import '../../manager/login/login_provider.dart';
import 'login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return AbsorbPointer(
          absorbing: loginProvider.isLoading,
          child: Form(
            key: loginProvider.loginFormKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: loginProvider.emailController,
                  hintText: 'Email Or User Name',
                  keyboardType: TextInputType.emailAddress,
                ),
                const HeightSpacer(size: 20),
                CustomTextField(
                  controller: loginProvider.passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: loginProvider.obscureText,
                  validator: (value) {
                    final errors = DataValidator.validatePassword(value!);
                    if (errors.isNotEmpty) return errors.join('\n');
                    return null;
                  },
                  suffixIcon: GestureDetector(
                    onTap: () {
                      loginProvider.obscureText = !loginProvider.obscureText;
                    },
                    child: CustomPasswordIcon(
                      obscureText: loginProvider.obscureText,
                    ),
                  ),
                ),
                const HeightSpacer(size: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: ReusableText(
                      text: 'Forgot Password?',
                      style: appStyle(
                        14,
                        AppColors.dark,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const HeightSpacer(size: 50),
                const LoginButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
