import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../manager/profile_provider.dart';
import 'profile_phone_number.dart';

class ProfileContactsData extends StatelessWidget {
  const ProfileContactsData({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return Column(
          children: [
            // email
            Container(
              padding: EdgeInsets.only(left: 8.w),
              width: AppConstants.width,
              height: AppConstants.height * 0.06,
              color: AppColors.lightGrey.withOpacity(0.3),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ReusableText(
                  text: profileProvider.user!.email,
                  style: appStyle(16, AppColors.dark, FontWeight.w600),
                ),
              ),
            ),
            const HeightSpacer(size: 20),
            // phone number
            const ProfilePhoneNumber(),
          ],
        );
      },
    );
  }
}
