import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/app_style.dart';
import '../../../../../core/common/widgets/reusable_text.dart';
import '../../../../../core/common/widgets/width_spacer.dart';
import '../../../../../core/config/app_router.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../generated/assets.dart';
import '../../manager/profile_provider.dart';

class ProfileUserInfoCard extends StatelessWidget {
  const ProfileUserInfoCard({super.key});

  _getUserAvatar(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (profileProvider.user == null) {
      return const AssetImage(Assets.imagesUser);
    } else {
      return NetworkImage(profileProvider.user?.profilePic.last ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.width,
      height: AppConstants.height * 0.12,
      color: AppColors.light,
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Row(
            children: [
              ClipOval(
                child: Hero(
                  tag: AppStrings.heroTagAvatarImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _getUserAvatar(context),
                  ),
                ),
              ),
              const WidthSpacer(size: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: profileProvider.user?.fullName ?? '',
                      style: appStyle(20, AppColors.dark, FontWeight.w600),
                    ),
                    Row(
                      children: [
                        const Icon(
                          MaterialIcons.location_pin,
                          color: AppColors.darkGrey,
                        ),
                        const WidthSpacer(size: 5),
                        ReusableText(
                          text: profileProvider.user?.location ?? '',
                          style:
                              appStyle(16, AppColors.darkGrey, FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const WidthSpacer(size: 10),
              GestureDetector(
                onTap: () async {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  final result = await Navigator.pushNamed(
                      context, AppRouter.editProfilePage);
                  if (result != null) {
                    Future.delayed(const Duration(milliseconds: 50), () {
                      AppConstants.showSnackBar(
                        context: context,
                        message: result.toString(),
                        isSuccess: true,
                      );
                    });
                  }
                },
                child: Icon(Feather.edit, size: 30.r),
              ),
            ],
          );
        },
      ),
    );
  }
}
