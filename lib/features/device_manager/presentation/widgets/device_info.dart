import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_outline_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class DeviceInfo extends StatelessWidget {
  const DeviceInfo({
    super.key,
    required this.device,
    required this.platform,
    required this.deviceIP,
    required this.date,
  });

  final String device;
  final String platform;
  final String deviceIP;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: platform,
          style: appStyle(
            22,
            AppColors.dark,
            FontWeight.bold,
          ),
        ),
        ReusableText(
          text: device,
          style: appStyle(
            22,
            AppColors.dark,
            FontWeight.bold,
          ),
        ),
        const HeightSpacer(size: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: 'Last Login: $date',
                  style: appStyle(16, AppColors.darkGrey, FontWeight.w400),
                ),
                ReusableText(
                  text: deviceIP,
                  style: appStyle(16, AppColors.darkGrey, FontWeight.w400),
                ),
              ],
            ),
            CustomOutlineBtn(
              text: 'Sign Out',
              color: AppColors.light,
              height: AppConstants.height * 0.05,
              width: AppConstants.width * 0.3,
              textAndBorderColor: AppColors.orange,
            ),
          ],
        ),
      ],
    );
  }
}
