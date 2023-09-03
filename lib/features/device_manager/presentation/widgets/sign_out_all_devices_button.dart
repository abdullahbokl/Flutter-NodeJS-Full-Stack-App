import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/managers/drawer_provider.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_colors.dart';

class SignOutAllDevicesButton extends StatelessWidget {
  const SignOutAllDevicesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          drawerProvider.currentIndex = 0;
          // todo : sign out all devices
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.loginPage, (route) => false);
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ReusableText(
            text: 'Sign Out All Devices',
            style: appStyle(
              16,
              AppColors.orange,
              FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
