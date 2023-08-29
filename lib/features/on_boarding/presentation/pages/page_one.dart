import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../generated/assets.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: AppConstants.width,
        height: AppConstants.height,
        color: AppColors.darkPurple,
        child: Column(
          children: [
            const HeightSpacer(size: 70),
            Image.asset(Assets.imagesPage1),
            const HeightSpacer(size: 40),
            Column(
              children: [
                ReusableText(
                  text: 'Find your dream job',
                  style: appStyle(
                    30,
                    AppColors.light,
                    FontWeight.w500,
                  ),
                ),
                const HeightSpacer(size: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
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
      ),
    );
  }
}
