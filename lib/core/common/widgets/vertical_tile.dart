import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../../generated/assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import 'app_style.dart';
import 'reusable_text.dart';
import 'salary_widget.dart';
import 'width_spacer.dart';

class VerticalTile extends StatelessWidget {
  const VerticalTile({
    super.key,
    this.onTap,
  });

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
                const CircleAvatar(
                  backgroundImage: AssetImage(Assets.imagesSlack),
                  backgroundColor: AppColors.lightGrey,
                  radius: 30,
                ),
                const WidthSpacer(size: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: 'Slack',
                      style: appStyle(20, AppColors.dark, FontWeight.w600),
                    ),
                    SizedBox(
                      width: AppConstants.width * 0.5,
                      child: ReusableText(
                        text: 'Full Stack Flutter Developer',
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
                  amount: '15',
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
