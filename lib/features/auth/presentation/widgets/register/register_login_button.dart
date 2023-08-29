import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/common/widgets/width_spacer.dart';
import '../../../../../core/utils/app_colors.dart';

class RegisterLoginButton extends StatelessWidget {
  const RegisterLoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReusableText(
          text: 'Already have an account?',
          style: appStyle(
            14,
            AppColors.darkBlue,
            FontWeight.w500,
          ),
        ),
        const WidthSpacer(size: 5),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: ReusableText(
            text: 'Sign In',
            style: appStyle(
              16,
              AppColors.lightBlue,
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
