import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
import '../../manager/edit_profile_provider.dart';

class UpdateProfileButton extends StatelessWidget {
  const UpdateProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (context, editProfileProvider, child) {
        return CustomButton(
          onTap: () async {
            if (!editProfileProvider.profileSetupFormKey.currentState!
                .validate()) {
              return;
            }
            await editProfileProvider.updateUserProfile(context);
          },
          isLoading: editProfileProvider.isUpdating,
          text: "Update Profile",
        );
      },
    );
  }
}
