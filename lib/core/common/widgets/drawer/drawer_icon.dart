import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../generated/assets.dart';
import '../../managers/drawer_provider.dart';

class DrawerIcon extends StatelessWidget {
  const DrawerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, child) {
        return GestureDetector(
          onTap: () {
            drawerProvider.drawerController.toggle!();
          },
          child: SvgPicture.asset(
            Assets.iconsMenu,
            width: 30.w,
            height: 30.h,
          ), // SvgPicture.asset
        );
      },
    ); // GestureDetector
  }
}
