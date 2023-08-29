import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../../features/chat/presentation/pages/chatpage.dart';
import '../../../features/device_manager/presentation/pages/devices_manager_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../services/logger.dart';
import '../widgets/drawer/drawer_item.dart';

class DrawerProvider extends ChangeNotifier {
  DrawerProvider() {
    Logger.logEvent(
        className: 'DrawerProvider', event: 'DrawerProvider created');
  }

  final ZoomDrawerController drawerController = ZoomDrawerController();
  final List<DrawerItemParams> _drawerItems = [
    const DrawerItemParams(
      text: 'Home',
      icon: AntDesign.home,
      page: HomePage(),
    ),
    const DrawerItemParams(
      text: 'Chat',
      icon: Ionicons.chatbubble_outline,
      page: ChatsPage(),
    ),
    const DrawerItemParams(
      text: 'Bookmarks',
      icon: Icons.bookmarks_outlined,
      page: BookMarksPage(),
    ),
    const DrawerItemParams(
      text: 'Device Manager',
      icon: MaterialCommunityIcons.devices,
      page: DeviceManagerPage(),
    ),
    const DrawerItemParams(
      text: 'Profile',
      icon: FontAwesome5Regular.user_circle,
      page: ProfilePage(),
    ),
  ];

  List<DrawerItemParams> get drawerItems => _drawerItems;

  int _currentIndex = 0;

  int get getCurrentIndex => _currentIndex;

  set currentIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
