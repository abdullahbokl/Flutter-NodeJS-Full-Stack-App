import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/common/widgets/salary_widget.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../generated/assets.dart';

class JobSummaryCard extends StatelessWidget {
  const JobSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.height * 0.27,
      width: AppConstants.width,
      color: AppColors.lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(Assets.imagesUser),
          ),
          const HeightSpacer(size: 10),
          ReusableText(
            text: 'Full Stack Flutter Developer',
            style: appStyle(22, AppColors.dark, FontWeight.w600),
          ),
          ReusableText(
            text: 'New York',
            style: appStyle(16, AppColors.darkGrey, FontWeight.normal),
          ),
          const HeightSpacer(size: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOutlineBtn(
                  width: AppConstants.width * 0.26,
                  height: AppConstants.height * 0.04,
                  text: 'Full-Time',
                  color: AppColors.light,
                  textAndBorderColor: AppColors.orange,
                ),
                SalaryWidget(
                  salary: SalaryModel(
                    amount: '15',
                    salaryType: SalaryType.perMonth,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
