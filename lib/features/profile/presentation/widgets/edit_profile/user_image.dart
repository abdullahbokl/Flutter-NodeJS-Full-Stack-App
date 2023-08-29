import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
            child: CircleAvatar(
              radius: 80.r,
              backgroundColor: AppColors.lightBlue,
              backgroundImage: imageHandler.profilePic != null
                  ? FileImage(imageHandler.profilePic!)
                  : Image.network(profileProvider.user!.profilePic.last).image,
              child: imageHandler.profilePic == null
                  ? const Center(
                      child: Icon(Icons.photo_filter_rounded, size: 50))
                  : null,
            ),
          );
        },
      ),
    );
  }
}
