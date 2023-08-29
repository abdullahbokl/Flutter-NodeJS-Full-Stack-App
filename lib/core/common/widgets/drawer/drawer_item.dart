import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../managers/drawer_provider.dart';
import '../app_style.dart';
import '../reusable_text.dart';
import '../width_spacer.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.text,
    required this.icon,
    required this.index,
    required this.isSelected,
  });

  final String text;
  final IconData icon;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, child) {
        return Container(
          margin: EdgeInsets.only(left: 20.w, bottom: 20.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: drawerProvider.getCurrentIndex == index
                    ? AppColors.light
                    : AppColors.lightGrey,
              ), // Icon
              const WidthSpacer(size: 12),
              ReusableText(
                text: text,
                style: appStyle(
                  12,
                  drawerProvider.getCurrentIndex == index
                      ? AppColors.light
                      : AppColors.lightGrey,
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DrawerItemParams {
  const DrawerItemParams({
    required this.text,
    required this.icon,
    required this.page,
  });

  final String text;
  final IconData icon;
  final Widget page;
}
