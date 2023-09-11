import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/profile/presentation/manager/profile_provider.dart';
import '../../../generated/assets.dart';
import '../managers/drawer_provider.dart';

class UserAvatarImage extends StatelessWidget {
  const UserAvatarImage({
    super.key,
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<DrawerProvider>(context, listen: false).currentIndex = 4;
      },
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final image = _getUserAvatar(context, imageUrl);
          return CircleAvatar(
            radius: 20,
            backgroundImage: image,
          );
        },
      ),
    );
  }

  _getUserAvatar(BuildContext context, String? imageUrl) {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final image = imageUrl ?? profileProvider.user?.profilePic.last ?? '';

    if (image == '') {
      return const AssetImage(Assets.imagesUser);
    } else {
      return NetworkImage(image);
    }
  }
}
