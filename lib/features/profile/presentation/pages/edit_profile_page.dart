import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../manager/edit_profile_provider.dart';
import '../manager/profile_provider.dart';
import '../widgets/edit_profile/add_skill_button.dart';
import '../widgets/edit_profile/personal_details.dart';
import '../widgets/edit_profile/skills_list_view.dart';
import '../widgets/edit_profile/update_profile_button.dart';
import '../widgets/edit_profile/user_image.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<EditProfileProvider>(context, listen: false)
        .loadData(Provider.of<ProfileProvider>(context, listen: false).user!);

    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Consumer<EditProfileProvider>(
              builder: (context, editProfileProvider, child) {
                return AbsorbPointer(
                  absorbing: editProfileProvider.isLoading,
                  child: Form(
                    key: editProfileProvider.profileSetupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const UserImage(),
                        const HeightSpacer(size: 5),
                        // personal details
                        ReusableText(
                          text: "Personal Details",
                          style: appStyle(35, AppColors.dark, FontWeight.bold),
                        ),
                        const HeightSpacer(size: 20),
                        const PersonalDetails(),
                        const HeightSpacer(size: 20),
                        // professional skills
                        ReusableText(
                          text: "Professional Skills",
                          style: appStyle(30, AppColors.dark, FontWeight.bold),
                        ),
                        const HeightSpacer(size: 10),
                        Form(
                          key: editProfileProvider.profileSkillsFormKey,
                          child: const Column(
                            children: [
                              SkillsListView(),
                              HeightSpacer(size: 10),
                              AddSkillButton(),
                            ],
                          ),
                        ),
                        const HeightSpacer(size: 20),
                        const UpdateProfileButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
