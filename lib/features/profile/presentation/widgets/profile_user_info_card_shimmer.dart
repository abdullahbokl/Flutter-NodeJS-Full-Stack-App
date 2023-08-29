import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/skelton.dart';
import '../../../../core/common/widgets/width_spacer.dart';

class ProfileUserInfoCardShimmer extends StatelessWidget {
  const ProfileUserInfoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Column(
        children: [
          const HeightSpacer(size: 20),
          // card shimmer

          Row(
            children: [
              // image shimmer
              const Skeleton(
                width: 100,
                height: 100,
              ),
              const WidthSpacer(size: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < 2; i++) ...[
                    const Skeleton(
                      width: 200,
                      height: 20,
                    ),
                    const HeightSpacer(size: 5),
                  ],
                ],
              ),
            ],
          ),

          const HeightSpacer(size: 15),
          // Bio shimmer

          for (var i = 0; i < 3; i++) ...[
            const Skeleton(
              width: 250,
              height: 25,
            ),
            const HeightSpacer(size: 10),
          ],

          const HeightSpacer(size: 30),
          // skills shimmer

          const Center(
            child: Skeleton(
              width: 200,
              height: 20,
            ),
          ),
          const HeightSpacer(size: 10),
          ListView.separated(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Skeleton(
                height: 30,
              );
            },
            separatorBuilder: (context, index) {
              return const HeightSpacer(size: 7);
            },
          )
        ],
      ),
    );
  }
}
