import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';

class RegisterGreetingMessages extends StatelessWidget {
  const RegisterGreetingMessages({super.key});

  // register a new account
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: 'Hello There!',
          style: appStyle(
            30,
            AppColors.dark,
            FontWeight.w600,
          ),
        ),
        ReusableText(
          text: 'Fill in your details to register',
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
