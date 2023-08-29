import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/height_spacer.dart';
import '../../manager/profile_provider.dart';
import '../profile_user_info_card_shimmer.dart';
import 'profile_bio.dart';
import 'profile_contacts_data.dart';
import 'profile_skills_card.dart';
import 'profile_user_info_card.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return profileProvider.user == null
            ? const ProfileUserInfoCardShimmer()
            : ListView(
                padding: EdgeInsets.zero,
                children: const [
                  // user info
                  ProfileUserInfoCard(),
                  HeightSpacer(size: 30),
                  // contact
                  ProfileContactsData(),
                  HeightSpacer(size: 30),
                  // bio
                  ProfileBio(),
                  HeightSpacer(size: 30),
                  // skills
                  ProfileSkillsCard(),
                  HeightSpacer(size: 30),
                ],
              );
      },
    );
  }
}
