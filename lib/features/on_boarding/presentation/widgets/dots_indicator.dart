import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../manager/on_boarding_provider.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppConstants.height * 0.08,
      left: 0,
      right: 0,
      child: Center(
        child: Consumer<OnBoardingProvider>(
          builder: (context, onBoardProvider, child) {
            return SmoothPageIndicator(
              controller: onBoardProvider.pageController,
              count: 3,
              effect: WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                spacing: 10,
                dotColor: Color(AppColors.darkGrey.value).withOpacity(0.5),
                activeDotColor: Color(AppColors.light.value),
              ),
            );
          },
        ),
      ),
    );
  }
}
