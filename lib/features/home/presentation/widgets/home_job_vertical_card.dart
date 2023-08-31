import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/common/widgets/salary_widget.dart';
import '../../../../core/common/widgets/width_spacer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class HomeJobVerticalCard extends StatelessWidget {
  const HomeJobVerticalCard({
    super.key,
    this.onTap,
    required this.job,
  });

  final JobModel job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: AppConstants.height * 0.16,
        width: AppConstants.width,
        color: AppColors.lightGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(job.imageUrl),
                  backgroundColor: AppColors.lightGrey,
                  radius: 30,
                ),
                const WidthSpacer(size: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: job.company,
                      style: appStyle(20, AppColors.dark, FontWeight.w600),
                    ),
                    SizedBox(
                      width: AppConstants.width * 0.5,
                      child: ReusableText(
                        text: job.title,
                        style:
                            appStyle(20, AppColors.darkGrey, FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 18,
                  child: Icon(Ionicons.chevron_forward),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: SalaryWidget(
                salary: SalaryModel(
                  amount: job.salary,
                  salaryType: SalaryType.perMonth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
