import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_flutter/core/common/models/job_model.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../widgets/job_skills_list_view.dart';
import '../widgets/job_summary_card.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.arrow_left),
        ),
        title: job.title,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(CupertinoIcons.bookmark, color: AppColors.orange),
          ),
        ],
      ),
      body: Padding(
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
                JobSkillsListView(requirements: job.requirements),
                const HeightSpacer(size: 50),
              ],
            ),
            // apply now button
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomOutlineBtn(
                onTap: () {},
                height: AppConstants.height * 0.06,
                text: 'Apply Now',
                color: AppColors.orange,
                textAndBorderColor: AppColors.light,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
