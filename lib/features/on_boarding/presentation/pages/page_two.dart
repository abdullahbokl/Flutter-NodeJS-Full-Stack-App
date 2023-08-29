import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../generated/assets.dart';

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.width,
      height: AppConstants.height,
      color: AppColors.darkBlue,
      child: Column(
        children: [
          const HeightSpacer(size: 65),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Image.asset(Assets.imagesPage2),
          ),
          const HeightSpacer(size: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Stable your self\nwith your abilities',
                textAlign: TextAlign.center,
                style: appStyle(
                  30,
                  AppColors.light,
                  FontWeight.w500,
                ),
              ),
              const HeightSpacer(size: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                // use normal text to avoid fading effect on the reusable text
                child: Text(
                  'We help you find your dream job according to your skills and experience',
                  textAlign: TextAlign.center,
                  style: appStyle(
                    14,
                    AppColors.light,
                    FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
