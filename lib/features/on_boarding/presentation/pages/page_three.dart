import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../generated/assets.dart';

class PageThree extends StatelessWidget {
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.width,
      height: AppConstants.height,
      color: AppColors.lightBlue,
      child: Column(
        children: [
          Flexible(
            child: Image.asset(
              Assets.imagesPage3,
              width: AppConstants.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          const HeightSpacer(size: 20),
          Column(
            children: [
              ReusableText(
                text: 'Welcome to JobHub',
                style: appStyle(
                  30,
                  AppColors.light,
                  FontWeight.w600,
                ),
              ),
              const HeightSpacer(size: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                // use normal text to avoid fading effect on the reusable text
                child: Text(
                  'We help you find your dream job according to your skills',
                  textAlign: TextAlign.center,
                  style: appStyle(
                    14,
                    AppColors.light,
                    FontWeight.normal,
                  ),
                ),
              ),
              const HeightSpacer(size: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomOutlineBtn(
                    onTap: () => Navigator.pushReplacementNamed(
                        context, AppRouter.login),
                    text: 'Login',
                    width: AppConstants.width * 0.4,
                    height: AppConstants.height * 0.06,
                    color: AppColors.lightBlue,
                    textAndBorderColor: AppColors.light,
                  ),
                  CustomOutlineBtn(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                      Navigator.pushNamed(context, AppRouter.register);
                    },
                    text: 'Sign Up',
                    width: AppConstants.width * 0.4,
                    height: AppConstants.height * 0.06,
                    color: AppColors.light,
                    textAndBorderColor: AppColors.lightBlue,
                  ),
                ],
              ),
              const HeightSpacer(size: 30),
              ReusableText(
                text: 'Continue as a guest',
                style: appStyle(
                  16,
                  AppColors.light,
                  FontWeight.w400,
                ),
              ),
              const HeightSpacer(size: 30),
            ],
          ),
        ],
      ),
    );
  }
}
