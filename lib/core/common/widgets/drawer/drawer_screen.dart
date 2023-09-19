import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../managers/drawer_provider.dart';
import 'drawer_screen_body.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, child) {
        return ZoomDrawer(
          menuScreenOverlayColor: AppColors.lightGreen,
          drawerShadowsBackgroundColor: AppColors.lightGreen,
          controller: drawerProvider.drawerController,
          menuScreen: const DrawerScreenBody(),
          mainScreen: currentScreen(context),
          borderRadius: 30,
          showShadow: true,
          angle: 0,
          slideWidth: 250,
          menuBackgroundColor: AppColors.lightBlue,
        );
      },
    );
  }

  Widget currentScreen(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context, listen: false);
    return drawerProvider.drawerItems[drawerProvider.getCurrentIndex].page;
  }
}
