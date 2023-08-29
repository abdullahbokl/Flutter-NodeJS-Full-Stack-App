import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';
import 'profile_skills_list_view.dart';

class ProfileSkillsCard extends StatelessWidget {
  const ProfileSkillsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.h),
            child: ReusableText(
              text: 'Skills',
              style: appStyle(
                16,
                AppColors.dark,
                FontWeight.w600,
              ),
            ),
          ),
          const HeightSpacer(size: 3),
          const ProfileSkillsListView(),
          const HeightSpacer(size: 20),
        ],
      ),
    );
  }
}
