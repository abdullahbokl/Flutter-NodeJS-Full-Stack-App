import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/widgets/custom_btn.dart';
import '../../manager/profile_provider.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return CustomButton(
          text: "Log Out",
          onTap: () {
            profileProvider.logout(context);
          },
          isLoading: profileProvider.isLoading,
        );
      },
    );
  }
}
