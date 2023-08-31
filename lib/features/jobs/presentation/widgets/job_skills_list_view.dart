import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/utils/app_colors.dart';

class JobSkillsListView extends StatelessWidget {
  const JobSkillsListView({
    super.key,
    required this.requirements,
  });

  final List<String> requirements;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requirements.length,
      itemBuilder: (context, index) {
        final req = requirements[index];
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
