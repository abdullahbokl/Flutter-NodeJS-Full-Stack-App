import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../manager/profile_provider.dart';

class ProfileSkillsListView extends StatelessWidget {
  const ProfileSkillsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: profileProvider.user!.skills.length,
            itemBuilder: (context, index) {
              final skill = profileProvider.user!.skills[index];
              return Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(8.h),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                width: AppConstants.width,
                height: AppConstants.height * 0.06,
                color: AppColors.light,
                child: ReusableText(
                  text: skill,
                  style: appStyle(
                    16,
                    AppColors.dark,
                    FontWeight.normal,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
