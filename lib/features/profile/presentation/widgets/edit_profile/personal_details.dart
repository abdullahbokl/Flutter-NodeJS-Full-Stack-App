import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_text_field.dart';
import '../../../../../core/common/widgets/height_spacer.dart';
import '../../manager/edit_profile_provider.dart';

class PersonalDetails extends StatelessWidget {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (context, editProfileProvider, child) {
        return Column(
          children: [
            CustomTextField(
              controller: editProfileProvider.fullNameController,
              hintText: "Full Name",
              keyboardType: TextInputType.text,
              validator: (fullName) {
                if (fullName!.trim().isEmpty) {
                  editProfileProvider.fullNameController.clear();
                  return "Please enter a valid name";
                }
                return null;
              },
            ),
            const HeightSpacer(size: 10),
            CustomTextField(
              controller: editProfileProvider.phoneController,
              hintText: "Phone Number",
              keyboardType: TextInputType.phone,
              validator: (phone) {
                if (phone!.trim().isEmpty) {
                  editProfileProvider.phoneController.clear();
                  return "Please enter a valid phone";
                }
                return null;
              },
            ),
            const HeightSpacer(size: 10),
            CustomTextField(
              controller: editProfileProvider.locationController,
              hintText: "Location",
              keyboardType: TextInputType.text,
              validator: (location) {
                if (location!.trim().isEmpty) {
                  editProfileProvider.locationController.clear();
                  return "Please enter a valid location";
                }
                return null;
              },
            ),
            const HeightSpacer(size: 10),
            CustomTextField(
              controller: editProfileProvider.bioController,
              hintText: "Bio",
              keyboardType: TextInputType.text,
              validator: (location) {
                if (location!.trim().isEmpty) {
                  editProfileProvider.bioController.clear();
                  return "Please enter a valid bio";
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
