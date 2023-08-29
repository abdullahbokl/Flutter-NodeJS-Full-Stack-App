import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../widgets/job_skills_list_view.dart';
import '../widgets/job_summary_card.dart';

class JobPage extends StatelessWidget {
  const JobPage({
    super.key,
    required this.title,
    required this.id,
  });

  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(CupertinoIcons.arrow_left),
        ),
        title: title,
        actions: const [
          Icon(Entypo.bookmarks),
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
                const JobSummaryCard(),
                const HeightSpacer(size: 20),
                // job description
                ReusableText(
                  text: 'Job description',
                  style: appStyle(22, AppColors.dark, FontWeight.w600),
                ),
                const HeightSpacer(size: 10),
                Text(
                  AppConstants.desc,
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
                const JobSkillsListView(),
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
