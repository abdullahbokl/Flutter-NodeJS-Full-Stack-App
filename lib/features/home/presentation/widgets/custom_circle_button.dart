import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../core/utils/app_colors.dart';

class CustomCircleButton extends StatelessWidget {
  const CustomCircleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Ionicons.chevron_forward),
    );
  }
}
