import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/on_boarding_provider.dart';
import '../pages/page_one.dart';
import '../pages/page_three.dart';
import '../pages/page_two.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardingProvider>(
      builder: (context, onBoardProvider, child) {
        return PageView(
          controller: onBoardProvider.pageController,
          children: const [
            PageOne(),
            PageTwo(),
            PageThree(),
          ],
          onPageChanged: (index) {
            if (index == 2) {
              onBoardProvider.isLastPage = true;
            } else {
              onBoardProvider.isLastPage = false;
            }
          },
        );
      },
    );
  }
}
