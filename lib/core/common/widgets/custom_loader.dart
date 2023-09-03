import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.color,
    this.size,
  });

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: SizedBox(
          height: size,
          width: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.light,
          ),
        ),
      ),
    );
  }
}
