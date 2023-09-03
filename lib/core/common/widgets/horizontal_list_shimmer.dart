import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import 'skeleton.dart';

class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Skeleton(
          width: AppConstants.width * 0.7,
        );
      },
    );
  }
}
