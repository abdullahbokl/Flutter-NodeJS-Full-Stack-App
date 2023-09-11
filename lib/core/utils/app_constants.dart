import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../features/profile/presentation/manager/profile_provider.dart';
import '../../generated/assets.dart';
import '../common/widgets/app_style.dart';
import '../common/widgets/reusable_text.dart';
import 'app_colors.dart';

class AppConstants {
  static double height = 812.h;
  static double width = 375.w;

  static String theId = "";

  static List<String> requirements = [
    "Design and Build sophisticated and highly scalable apps using Flutter.",
    "Build custom packages in Flutter using the functionalities and APIs already available in native Android and IOS.",
    "Translate and Build the designs and Wireframes into high quality responsive UI code.",
    "Explore feasible architectures for implementing new features.",
    "Resolve any problems existing in the system and suggest and add new features in the complete system.",
    "Suggest space and time efficient Data Structures.",
  ];

  static String desc =
      "Flutter Developer is responsible for running and designing product application features across multiple devices across platforms. Flutter is Google's UI toolkit for building beautiful, natively compiled apps for mobile, web, and desktop from a single codebase. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.";

  static List<String> skills = [
    "Node JS",
    "Java SpringBoot",
    "Flutter and Dart",
    "Firebase",
    "AWS",
  ];

  // User
  static String userToken = "";

  static String userId = "";

  static getCurrentUserImage(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final images = profileProvider.user?.profilePic;

    if (images == null || images.isEmpty) {
      return const AssetImage(Assets.imagesUser);
    } else {
      return NetworkImage(profileProvider.user?.profilePic.last ?? '');
    }
  }

  /// Show snack bar
  static showSnackBar({
    required BuildContext context,
    required String message,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          child: ReusableText(
            text: message,
            style: appStyle(
              16,
              isSuccess ? Colors.green : AppColors.orange,
              FontWeight.w600,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show dialog
  static AwesomeDialog showAwesomeDialog({
    required BuildContext context,
    required DialogType dialogType,
    required String dialogTitle,
    required String message,
    required Color titleColor,
    String? btnOkText,
    String? btnCancelText,
    VoidCallback? onCancelTap,
    VoidCallback? onOkTap,
    void Function(DismissType)? onDismissCallback,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.bottomSlide,
      title: dialogTitle,
      titleTextStyle: TextStyle(
          color: titleColor, fontWeight: FontWeight.bold, fontSize: 20),
      desc: message,
      descTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black.withOpacity(0.5)),
      btnOkOnPress: onOkTap,
      onDismissCallback: onDismissCallback,
      btnCancelOnPress: onCancelTap,
      btnOkText: btnOkText,
      btnCancelText: btnCancelText,
    )..show();
  }
}
