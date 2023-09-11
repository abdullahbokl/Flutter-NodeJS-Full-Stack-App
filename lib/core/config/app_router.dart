import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/manager/register/register_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/chat/presentation/pages/conversation_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/jobs/presentation/manager/job_details_provider.dart';
import '../../features/jobs/presentation/pages/job_details_page.dart';
import '../../features/jobs/presentation/pages/jobs_list_page.dart';
import '../../features/on_boarding/presentation/manager/on_boarding_provider.dart';
import '../../features/on_boarding/presentation/on_boarding_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../common/models/job_model.dart';
import '../common/widgets/drawer/drawer_screen.dart';
import 'redirects.dart';

class AppRouter {
  static const String onBoarding = '/onBoarding';
  static const String drawer = '/drawer';
  static const String loginPage = '/login';
  static const String registerPage = '/registerPage';
  static const String profilePage = '/profilePage';
  static const String homePage = '/homePage';
  static const String searchPage = '/searchPage';
  static const String jobsListPage = '/jobsListPage';
  static const String jobDetailsPage = '/jobDetailsPage';
  static const String editProfilePage = '/editProfilePage';
  static const String conversationPage = '/conversationPage';

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
        case loginPage:
          return MaterialPageRoute(
            builder: (_) => const LoginPage(),
          );
        case registerPage:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<RegisterProvider>(
              create: (BuildContext context) => RegisterProvider(),
              child: const RegisterPage(),
            ),
          );
        case homePage:
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
          );
        case profilePage:
          return MaterialPageRoute(
            builder: (_) => const ProfilePage(),
          );
        case editProfilePage:
          return MaterialPageRoute(
            builder: (_) => const EditProfilePage(),
          );
        case searchPage:
          return MaterialPageRoute(
            builder: (_) => const SearchPage(),
          );
        case jobsListPage:
          return MaterialPageRoute(
            builder: (_) => JobsListPage(title: settings.arguments as String),
          );
        case jobDetailsPage:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<JobDetailsProvider>(
              create: (BuildContext context) => JobDetailsProvider(),
              child: JobDetailsPage(job: settings.arguments as JobModel),
            ),
          );
        case conversationPage:
          return MaterialPageRoute(
            builder: (_) => const ConversationPage(),
          );
        case drawer:
          return MaterialPageRoute(
            builder: (_) => const DrawerScreen(),
          );
      }
      cnt++;
    }
  }
}
