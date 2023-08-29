import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: color ?? AppColors.light,
        ),
      ),
    );
  }
}
