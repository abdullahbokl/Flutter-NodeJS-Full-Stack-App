import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomPasswordIcon extends StatelessWidget {
  const CustomPasswordIcon({
    super.key,
    required this.obscureText,
  });

  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return obscureText
        ? const Icon(
            Icons.visibility_off,
            color: AppColors.dark,
          )
        : const Icon(
            Icons.visibility,
            color: AppColors.orange,
          );
  }
}
