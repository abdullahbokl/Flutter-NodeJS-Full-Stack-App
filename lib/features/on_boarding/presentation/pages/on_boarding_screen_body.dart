import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/on_boarding_provider.dart';
import '../widgets/dots_indicator.dart';
import '../widgets/on_boarding_buttons.dart';
import '../widgets/on_boarding_page_view.dart';

class OnBoardingScreenBody extends StatelessWidget {
  const OnBoardingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const OnBoardingPageView(),
        Consumer<OnBoardingProvider>(
          builder: (context, onBoardProvider, child) {
            return Stack(
              children: [
                if (!onBoardProvider.isLastPage) ...[
                  const DotsIndicator(),
                  const OnBoardingButtons(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
