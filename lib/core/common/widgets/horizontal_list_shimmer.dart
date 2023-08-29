import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import 'skeleton.dart';

class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Skeleton(
          width: AppConstants.width * 0.6,
        );
      },
      separatorBuilder: (context, index) => const VerticalDivider(),
    );
  }
}
