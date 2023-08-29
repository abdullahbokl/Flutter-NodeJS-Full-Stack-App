import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../manager/edit_profile_provider.dart';

class SkillsListView extends StatelessWidget {
  const SkillsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final editProfileProvider =
        Provider.of<EditProfileProvider>(context, listen: false);
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: editProfileProvider.skillsControllers.length,
      itemBuilder: (context, index) {
        return CustomTextField(
          controller: editProfileProvider.skillsControllers[index],
          hintText: "Professional Skill",
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.trim().isEmpty) {
              editProfileProvider.skillsControllers[index].clear();
              return "Please enter a skill";
            }
            return null;
          },
        );
      },
      separatorBuilder: (context, index) {
        return const HeightSpacer(size: 10);
      },
    );
  }
}
