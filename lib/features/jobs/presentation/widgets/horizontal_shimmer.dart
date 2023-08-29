import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class HorizontalShimmer extends StatelessWidget {
  const HorizontalShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        ShimmerEffect(
          curve: Curves.easeInBack,
          duration: Duration(seconds: 1),
          colors: [
            AppColors.lightGrey,
            AppColors.lightBlue,
            AppColors.lightGrey,
          ],
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        width: AppConstants.width * 0.5,
        color: AppColors.lightGrey,
      ),
    );
  }
}
