import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';

class LoginGreetingMessages extends StatelessWidget {
  const LoginGreetingMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: 'Welcome Back!',
          style: appStyle(
            30,
            AppColors.dark,
            FontWeight.w600,
          ),
        ),
        ReusableText(
          text: 'Fill in your details to login',
          style: appStyle(
            16,
            AppColors.darkGrey,
            FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
