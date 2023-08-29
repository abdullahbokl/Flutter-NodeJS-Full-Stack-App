import 'package:flutter/material.dart';

import '../../../../core/common/widgets/horizontal_tile.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_constants.dart';

class PopularJobsListView extends StatelessWidget {
  const PopularJobsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.height * 0.28,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) => JobHorizontalTile(
          onTap: () => Navigator.pushNamed(context, AppRouter.jobPage),
        ),
      ),
    );
  }
}
