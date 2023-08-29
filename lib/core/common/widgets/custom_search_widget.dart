import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/app_colors.dart';
import 'app_style.dart';
import 'height_spacer.dart';
import 'reusable_text.dart';
import 'width_spacer.dart';

class CustomSearchWidget extends StatelessWidget {
  const CustomSearchWidget({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Feather.search, color: AppColors.lightGreen, size: 20.h),
              const WidthSpacer(size: 20),
              ReusableText(
                text: 'Search for jobs',
                style: appStyle(18, AppColors.lightGreen, FontWeight.w500),
              ),
              const Spacer(),
              Icon(FontAwesome.sliders, color: AppColors.darkGrey, size: 20.h),
            ],
          ),
          const HeightSpacer(size: 7),
          Divider(
            color: AppColors.darkGrey,
            thickness: 0.5,
            endIndent: 40.w,
          ),
        ],
      ),
    );
  }
}
