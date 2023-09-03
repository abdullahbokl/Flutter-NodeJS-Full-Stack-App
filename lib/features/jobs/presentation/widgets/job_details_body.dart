import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import 'job_requirements_list_view.dart';
import 'job_summary_card.dart';

class JobDetailsBody extends StatelessWidget {
  const JobDetailsBody({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const HeightSpacer(size: 30),
              // summary
              JobSummaryCard(job: job),
              const HeightSpacer(size: 20),
              // job description
              ReusableText(
                text: 'Job description',
                style: appStyle(22, AppColors.dark, FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              Text(
                job.description,
                textAlign: TextAlign.justify,
                maxLines: 8,
                style: appStyle(16, AppColors.darkGrey, FontWeight.normal),
              ),
              const HeightSpacer(size: 20),
              // job requirements
              ReusableText(
                text: 'Job requirements',
                style: appStyle(22, AppColors.dark, FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              JobRequirementsListView(requirements: job.requirements),
              const HeightSpacer(size: 50),
            ],
          ),
          // apply now button
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              onTap: () {},
              text: 'Apply Now',
              color: AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
