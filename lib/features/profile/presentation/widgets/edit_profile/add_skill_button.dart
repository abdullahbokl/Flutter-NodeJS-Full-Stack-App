import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../manager/edit_profile_provider.dart';

class AddSkillButton extends StatelessWidget {
  const AddSkillButton({super.key});

  @override
  Widget build(BuildContext context) {
    final editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton(
        backgroundColor: AppColors.lightGreen,
        child: const Icon(Icons.add, color: AppColors.light),
        onPressed: () {
          if (!editProfileProvider.profileSkillsFormKey.currentState!
              .validate()) {
            editProfileProvider.skillsControllers.last.clear();
            return;
          }
          editProfileProvider.addSkillController();
        },
      ),
    );
  }
}
