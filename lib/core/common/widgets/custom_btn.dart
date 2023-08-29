import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import 'app_style.dart';
import 'custom_loader.dart';
import 'reusable_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.onTap,
    this.isLoading,
  });

  final String text;
  final Color? color;
  final VoidCallback? onTap;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onTap!();
      },
      child: Container(
        color: AppColors.orange,
        width: AppConstants.width,
        height: AppConstants.height * 0.065,
        child: Center(
          child: isLoading ?? false
              ? const CustomLoader()
              : ReusableText(
                  text: text,
                  style: appStyle(
                    16,
                    AppColors.light,
                    FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
