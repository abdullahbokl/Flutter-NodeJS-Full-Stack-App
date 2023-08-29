import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../generated/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import 'app_style.dart';
import 'height_spacer.dart';
import 'reusable_text.dart';
import 'salary_widget.dart';
import 'width_spacer.dart';

class JobHorizontalTile extends StatelessWidget {
  const JobHorizontalTile({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: EdgeInsets.only(right: 12.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            height: AppConstants.height * 0.27,
            width: AppConstants.width * 0.7,
            color: AppColors.lightGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage(Assets.imagesFacebook),
                    ),
                    const WidthSpacer(size: 15),
                    ReusableText(
                      text: 'FaceBook',
                      style: appStyle(26, AppColors.dark, FontWeight.w600),
                    ),
                  ],
                ),
                const HeightSpacer(size: 15),
                ReusableText(
                  text: 'Full Stack Flutter Developer',
                  style: appStyle(20, AppColors.dark, FontWeight.w600),
                ),
                ReusableText(
                  text: 'Washington, DC',
                  style: appStyle(16, AppColors.darkGrey, FontWeight.w600),
                ),
                Row(
                  children: [
                    SalaryWidget(
                      salary: SalaryModel(
                        amount: '15',
                        salaryType: SalaryType.perMonth,
                      ),
                    ),
                    const Spacer(),
                    const CircleAvatar(
                      child: Icon(Ionicons.chevron_forward),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
