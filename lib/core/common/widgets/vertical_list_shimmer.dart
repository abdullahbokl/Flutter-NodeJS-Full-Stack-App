import 'package:flutter/material.dart';

import '../../utils/app_constants.dart';
import 'skeleton.dart';

class VerticalListShimmer extends StatelessWidget {
  const VerticalListShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Skeleton(
          height: AppConstants.height * 0.15,
          width: AppConstants.width * 0.7,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
