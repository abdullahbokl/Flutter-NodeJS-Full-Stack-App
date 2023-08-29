import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

class JobSkillsListView extends StatelessWidget {
  const JobSkillsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppConstants.requirements.length,
      itemBuilder: (context, index) {
        final req = AppConstants.requirements[index];
        return Text(
          '• $req\n',
          textAlign: TextAlign.justify,
          maxLines: 3,
          style: appStyle(16, AppColors.darkGrey, FontWeight.normal),
        );
      },
    );
  }
}
