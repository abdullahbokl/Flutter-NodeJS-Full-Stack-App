import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_colors.dart';
import 'app_style.dart';
import 'reusable_text.dart';

AppBar customAppBar({
  Widget? leading,
  String? title,
  List<Widget>? actions,
}) {
  return AppBar(
    iconTheme: const IconThemeData(),
    backgroundColor: AppColors.light,
    elevation: 0,
    automaticallyImplyLeading: false,
    leadingWidth: 70.w,
    leading: leading,
    actions: actions,
    centerTitle: true,
    title: ReusableText(
      text: title ?? '',
      style: appStyle(
        16,
        AppColors.dark,
        FontWeight.w600,
      ),
    ),
  );
}
