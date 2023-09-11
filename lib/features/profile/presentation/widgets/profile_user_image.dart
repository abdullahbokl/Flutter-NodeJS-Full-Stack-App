import 'package:flutter/material.dart';
import 'package:jobhub_flutter/core/utils/app_constants.dart';
import 'package:provider/provider.dart';

import '../../../../generated/assets.dart';
import '../manager/profile_provider.dart';

class ProfileUserImage extends StatelessWidget {
  const ProfileUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CircleAvatar(
        radius: 40,
        backgroundImage: AppConstants.getCurrentUserImage(context),
      ),
    );
  }

  _getUserAvatar(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final images = profileProvider.user?.profilePic;

    if (images == null || images.isEmpty) {
      return const AssetImage(Assets.imagesUser);
    } else {
      return NetworkImage(profileProvider.user?.profilePic.last ?? '');
    }
  }
}
