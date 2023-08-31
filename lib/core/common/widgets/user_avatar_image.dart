import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/profile/presentation/manager/profile_provider.dart';
import '../../../generated/assets.dart';

class UserAvatarImage extends StatelessWidget {
  const UserAvatarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return CircleAvatar(
          radius: 15,
          backgroundImage: _getUserAvatar(context),
        );
      },
    );
  }

  _getUserAvatar(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (profileProvider.user == null) {
      return const AssetImage(Assets.imagesUser);
    } else {
      return NetworkImage(profileProvider.user?.profilePic.last ?? '');
    }
  }
}
