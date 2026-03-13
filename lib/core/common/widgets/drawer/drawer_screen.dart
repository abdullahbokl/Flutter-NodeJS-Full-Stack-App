import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../../utils/app_colors.dart';
import 'drawer_screen_body.dart';

class DrawerScreen extends StatelessWidget {
  /// Supports both ShellRoute (child passed in) and legacy drawer modes.
  final Widget? child;
  const DrawerScreen({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreenOverlayColor: AppColors.primary.withValues(alpha: 0.08),
      drawerShadowsBackgroundColor: AppColors.primary.withValues(alpha: 0.08),
      menuScreen: const DrawerScreenBody(),
      mainScreen: child ?? const SizedBox.shrink(),
      borderRadius: 28,
      showShadow: true,
      angle: 0.0,
      slideWidth: 260,
      menuBackgroundColor: AppColors.backgroundDark,
    );
  }
}
