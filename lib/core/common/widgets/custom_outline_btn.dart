import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_style.dart';
import 'reusable_text.dart';

class CustomOutlineBtn extends StatelessWidget {
  const CustomOutlineBtn({
    super.key,
    required this.text,
    required this.color,
    this.textAndBorderColor,
    this.onTap,
    this.width,
    this.height,
  });

  final String text;
  final Color color;
  final Color? textAndBorderColor;
  final void Function()? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: textAndBorderColor ?? AppColors.light,
            width: 1,
          ),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: appStyle(
              16,
              textAndBorderColor ?? AppColors.light,
              FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
