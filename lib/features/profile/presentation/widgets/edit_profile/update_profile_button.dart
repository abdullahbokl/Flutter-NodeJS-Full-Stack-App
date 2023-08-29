import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
import '../../../../../core/utils/app_constants.dart';
import '../../manager/edit_profile_provider.dart';

class UpdateProfileButton extends StatelessWidget {
  const UpdateProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    final editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    return CustomButton(
      onTap: () async {
        if (!editProfileProvider.profileSetupFormKey.currentState!.validate()) {
          return;
        }
        editProfileProvider.isLoading = true;
        try {
          await editProfileProvider.updateUserProfile(context);
          if (context.mounted) {
            Navigator.of(context).pop("Profile Updated Successfully");
          }
        } catch (e) {
          if (context.mounted) {
            await AppConstants.showSnackBar(
              context: context,
              message: e.toString(),
            );
          }
        }
        editProfileProvider.isLoading = false;
      },
      isLoading: editProfileProvider.isLoading,
      text: "Update Profile",
    );
  }
}
