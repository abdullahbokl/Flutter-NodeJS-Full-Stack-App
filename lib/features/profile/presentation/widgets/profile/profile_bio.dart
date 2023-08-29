import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../manager/profile_provider.dart';

class ProfileBio extends StatelessWidget {
  const ProfileBio({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: AppColors.dark.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        profileProvider.user!.bio!,
        textAlign: TextAlign.justify,
        style: const TextStyle(
          color: AppColors.darkBlue,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
