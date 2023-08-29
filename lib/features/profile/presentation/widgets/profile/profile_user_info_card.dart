import 'package:cached_network_image/cached_network_image.dart';
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
import '../../manager/profile_provider.dart';

class ProfileUserInfoCard extends StatelessWidget {
  const ProfileUserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.width,
      height: AppConstants.height * 0.12,
      color: AppColors.light,
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final images = profileProvider.user?.profilePic ?? [];
          return Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 80.r,
                  height: 80.r,
                  imageUrl: images.isNotEmpty
                      ? images.first
                      : 'https://faraitltd.com/wp-content/uploads/2023/02/Screenshot_7.jpg',
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
                  final result =
                      await Navigator.pushNamed(context, AppRouter.editProfile);
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
