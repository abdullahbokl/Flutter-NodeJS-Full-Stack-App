import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_style.dart';
import 'reusable_text.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ReusableText(
            text: text, style: appStyle(20, AppColors.dark, FontWeight.w600)),
        GestureDetector(
          onTap: onTap,
          child: ReusableText(
            text: 'View all',
            style: appStyle(18, AppColors.orange, FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
