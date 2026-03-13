import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/config/app_setup.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../pages/page_one.dart';
import '../pages/page_three.dart';
import '../pages/page_two.dart';

/// Self-contained on-boarding screen — no provider needed.
/// All state (page index, controller) lives here.
class OnBoardingScreenBody extends StatefulWidget {
  const OnBoardingScreenBody({super.key});

  @override
  State<OnBoardingScreenBody> createState() => _OnBoardingScreenBodyState();
}

class _OnBoardingScreenBodyState extends State<OnBoardingScreenBody> {
  final _controller = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    // Mark that the user has seen the on-boarding
    getIt<SharedPreferences>().setBool('isFirstTime', false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() => _isLastPage = index == 2),
          children: const [PageOne(), PageTwo(), PageThree()],
        ),
        if (!_isLastPage) ...[
          _DotsIndicator(controller: _controller),
          _NextSkipButtons(controller: _controller),
        ],
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final PageController controller;
  const _DotsIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppConstants.height * 0.08,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          controller: controller,
          count: 3,
          effect: WormEffect(
            dotHeight: 12,
            dotWidth: 12,
            spacing: 10,
            dotColor: AppColors.darkGrey.withValues(alpha: 0.5),
            activeDotColor: AppColors.light,
          ),
        ),
      ),
    );
  }
}

class _NextSkipButtons extends StatelessWidget {
  final PageController controller;
  const _NextSkipButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => controller.animateToPage(
                2,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
              child: const Text('Skip', style: TextStyle(color: AppColors.light, fontSize: 16)),
            ),
            TextButton(
              onPressed: () => controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              ),
              child: const Text('Next', style: TextStyle(color: AppColors.light, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
