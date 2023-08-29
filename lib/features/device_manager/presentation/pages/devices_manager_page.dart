import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/drawer/drawer_icon.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/utils/app_colors.dart';
import '../widgets/device_info.dart';
import '../widgets/sign_out_all_devices_button.dart';

class DeviceManagerPage extends StatelessWidget {
  const DeviceManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: Padding(
          padding: EdgeInsets.all(12.h),
          child: const DrawerIcon(),
        ),
        title: 'Device Manager',
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpacer(size: 50),
                      Text(
                        'you are logged in into your account from the following devices',
                        style: appStyle(
                          16,
                          AppColors.dark,
                          FontWeight.normal,
                        ),
                      ),
                      const HeightSpacer(size: 50),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            child: const DeviceInfo(
                              device: 'Samsung Galaxy S10',
                              platform: 'Android',
                              deviceIP: '127.0.0.1',
                              date: '12/12/2020',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SignOutAllDevicesButton(),
          ],
        ),
      ),
    );
  }
}
