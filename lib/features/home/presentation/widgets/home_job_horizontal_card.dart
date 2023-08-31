import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/common/widgets/salary_widget.dart';
import '../../../../core/common/widgets/width_spacer.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class HomeJobHorizontalCard extends StatelessWidget {
  const HomeJobHorizontalCard({
    super.key,
    required this.job,
    this.onTap,
  });

  final JobModel job;
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
                    CircleAvatar(
                      backgroundImage: NetworkImage(job.imageUrl),
                    ),
                    const WidthSpacer(size: 15),
                    ReusableText(
                      text: job.company,
                      style: appStyle(26, AppColors.dark, FontWeight.w600),
                    ),
                  ],
                ),
                const HeightSpacer(size: 15),
                ReusableText(
                  text: job.title,
                  style: appStyle(20, AppColors.dark, FontWeight.w600),
                ),
                ReusableText(
                  text: job.location,
                  style: appStyle(16, AppColors.darkGrey, FontWeight.w600),
                ),
                Row(
                  children: [
                    SalaryWidget(
                      salary: SalaryModel(
                        amount: job.salary,
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
