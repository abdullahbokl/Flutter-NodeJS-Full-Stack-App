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
    final cacheWidth = (MediaQuery.sizeOf(context).width * 0.5).round();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.imagesOptimizedSearch,
          cacheWidth: cacheWidth,
        ),
        ReusableText(
          text: message,
          style: appStyle(24, AppColors.dark, FontWeight.bold),
        ),
      ],
    );
  }
}
