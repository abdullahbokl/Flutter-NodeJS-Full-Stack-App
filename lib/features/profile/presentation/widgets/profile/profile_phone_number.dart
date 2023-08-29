import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/common/widgets/width_spacer.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../generated/assets.dart';
import '../../manager/profile_provider.dart';

class ProfilePhoneNumber extends StatelessWidget {
  const ProfilePhoneNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 8.w),
      width: AppConstants.width,
      height: AppConstants.height * 0.06,
      color: AppColors.lightGrey.withOpacity(0.3),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            ClipOval(
              child: SvgPicture.asset(
                Assets.iconsEg,
                width: 20.w,
                height: 20.h,
              ),
            ),
            const WidthSpacer(size: 15),
            ReusableText(
              text: profileProvider.user!.phone!,
              style: appStyle(
                16,
                AppColors.dark,
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
