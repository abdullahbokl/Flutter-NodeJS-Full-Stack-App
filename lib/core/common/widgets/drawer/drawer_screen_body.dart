import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../managers/drawer_provider.dart';
import 'drawer_item.dart';

class DrawerScreenBody extends StatelessWidget {
  const DrawerScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerProvider>(
      builder: (context, drawerProvider, child) {
        return GestureDetector(
          onDoubleTap: () {
            drawerProvider.drawerController.toggle!();
          },
          child: Scaffold(
            backgroundColor: AppColors.lightBlue,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                drawerProvider.drawerItems.length,
                (index) => GestureDetector(
                  onTap: () async {
                    drawerProvider.drawerController.toggle!();
                    drawerProvider.currentIndex = index;
                  },
                  child: DrawerItem(
                    text: drawerProvider.drawerItems[index].text,
                    icon: drawerProvider.drawerItems[index].icon,
                    index: index,
                    isSelected: drawerProvider.getCurrentIndex == index,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
