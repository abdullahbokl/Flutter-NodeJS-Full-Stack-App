import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/manager/register/register_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/jobs/presentation/pages/job_page.dart';
import '../../features/on_boarding/presentation/manager/on_boarding_provider.dart';
import '../../features/on_boarding/presentation/on_boarding_screen.dart';
import '../../features/profile/presentation/manager/edit_profile_provider.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../common/widgets/drawer/drawer_screen.dart';
import 'redirects.dart';

class AppRouter {
  static const String onBoarding = '/onBoarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String search = '/search';
  static const String jobPage = '/jobPage';
  static const String drawer = '/drawer';
  static const String editProfile = '/editProfile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    int cnt = 0;
    String route = Redirect.middleware(settings.name ?? onBoarding);
    while (true) {
      if (cnt > 0) {
        route = Redirect.middleware(onBoarding);
        cnt = 0;
      }
      switch (route) {
        case onBoarding:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<OnBoardingProvider>(
              create: (BuildContext context) => OnBoardingProvider(),
              lazy: true,
              child: const OnBoardingScreen(),
            ),
          );
        case login:
          return MaterialPageRoute(
            builder: (_) => const LoginPage(),
          );
        case register:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<RegisterProvider>(
              create: (BuildContext context) => RegisterProvider(),
              child: const RegisterPage(),
            ),
          );
        case profile:
          return MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          );
        case home:
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
          );
        case search:
          return MaterialPageRoute(
            builder: (_) => const SearchPage(),
          );
        case jobPage:
          return MaterialPageRoute(
            builder: (_) => const JobPage(title: 'title', id: 'id'),
          );
        case drawer:
          return MaterialPageRoute(
            builder: (_) => const DrawerScreen(),
          );
        case editProfile:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (BuildContext context) => EditProfileProvider(),
              child: const EditProfilePage(),
            ),
          );
      }
      cnt++;
    }
  }
}
