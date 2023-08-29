import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/assets.dart';

class NoChatsWidget extends StatelessWidget {
  const NoChatsWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.imagesOptimizedSearch),
        ReusableText(
          text: message,
          style: appStyle(24, AppColors.dark, FontWeight.bold),
        ),
      ],
    );
  }
}
