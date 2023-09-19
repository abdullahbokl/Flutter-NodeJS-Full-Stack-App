import 'package:flutter/material.dart';
import 'package:jobhub_flutter/core/utils/app_constants.dart';
import 'package:provider/provider.dart';

import '../manager/profile_provider.dart';

class ProfileUserImage extends StatelessWidget {
  const ProfileUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return CircleAvatar(
            radius: 40,
            backgroundImage: AppConstants.getCurrentUserImage(context),
          );
        },
      ),
    );
  }
}
