import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/common/widgets/salary_widget.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class JobSummaryCard extends StatelessWidget {
  const JobSummaryCard({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.height * 0.25,
      width: AppConstants.width,
      color: AppColors.lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(job.imageUrl),
          ),
          const HeightSpacer(size: 10),
          ReusableText(
            text: job.company,
            style: appStyle(22, AppColors.dark, FontWeight.w600),
          ),
          ReusableText(
            text: job.location,
            style: appStyle(16, AppColors.darkGrey, FontWeight.normal),
          ),
          const HeightSpacer(size: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomOutlineBtn(
                  width: AppConstants.width * 0.26,
                  height: AppConstants.height * 0.04,
                  text: job.period,
                  color: AppColors.light,
                  textAndBorderColor: AppColors.orange,
                ),
                SalaryWidget(
                  salary: SalaryModel(
                    amount: job.salary,
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
