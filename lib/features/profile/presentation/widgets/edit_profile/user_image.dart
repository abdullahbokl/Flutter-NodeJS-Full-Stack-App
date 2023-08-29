import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobhub_flutter/core/utils/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../manager/edit_profile_provider.dart';
import '../../manager/profile_provider.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return Align(
      alignment: Alignment.center,
      child: Consumer<EditProfileProvider>(
        builder: (context, imageHandler, child) {
          return GestureDetector(
            onTap: () async {
              await imageHandler.pickImage(
                context: context,
                imageSource: ImageSource.gallery,
              );
            },
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                var image = AppConstants.getCurrentUserImage(context);
                if (imageHandler.profilePic != null) {
                  image = FileImage(imageHandler.profilePic!);
                }

                return CircleAvatar(
                  radius: 80.r,
                  backgroundColor: AppColors.lightBlue,
                  backgroundImage: image,
                  child: imageHandler.profilePic == null
                      ? const Center(
                          child: Icon(Icons.photo_filter_rounded, size: 50))
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
