import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
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
  static const String onBoarding     = '/';
  static const String loginPage      = '/login';
  static const String registerPage   = '/register';
  static const String homePage       = '/home';
  static const String searchPage     = '/search';
  static const String bookmarksPage  = '/bookmarks';
  static const String chatPage       = '/chat';
  static const String profilePage    = '/profile';
  static const String editProfilePage = '/profile/edit';
  static const String jobsListPage   = '/jobs';
  static const String jobDetailsPage = '/jobs/:id';
  static const String conversationPage = '/conversation';
  static const String drawer         = '/drawer';

  /// Legacy Navigator-based router (kept for pages not yet migrated).
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
          return MaterialPageRoute(builder: (_) => const LoginPage());
        case registerPage:
          return MaterialPageRoute(builder: (_) => const RegisterPage());
        case homePage:
          return MaterialPageRoute(builder: (_) => const HomePage());
        case profilePage:
          return MaterialPageRoute(builder: (_) => const ProfilePage());
        case editProfilePage:
          return MaterialPageRoute(builder: (_) => const EditProfilePage());
        case searchPage:
          return MaterialPageRoute(builder: (_) => const SearchPage());
        case jobsListPage:
          return MaterialPageRoute(
            builder: (_) => JobsListPage(title: settings.arguments as String?),
          );
        case jobDetailsPage:
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<JobDetailsProvider>(
              create: (BuildContext context) => JobDetailsProvider(),
              child: JobDetailsPage(job: settings.arguments as JobModel),
            ),
          );
        case conversationPage:
          return MaterialPageRoute(builder: (_) => const ConversationPage());
        case drawer:
          return MaterialPageRoute(builder: (_) => const DrawerScreen());
      }
      cnt++;
    }
  }
}

/// GoRouter instance used by [MyApp].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.onBoarding,
  routes: [
    GoRoute(
      path: AppRouter.onBoarding,
      builder: (_, __) => ChangeNotifierProvider<OnBoardingProvider>(
        create: (_) => OnBoardingProvider(),
        child: const OnBoardingScreen(),
      ),
    ),
    GoRoute(path: AppRouter.loginPage,    builder: (_, __) => const LoginPage()),
    GoRoute(path: AppRouter.registerPage, builder: (_, __) => const RegisterPage()),
    ShellRoute(
      builder: (ctx, state, child) => DrawerScreen(child: child),
      routes: [
        GoRoute(path: AppRouter.homePage,       builder: (_, __) => const HomePage()),
        GoRoute(path: AppRouter.searchPage,     builder: (_, __) => const SearchPage()),
        GoRoute(path: AppRouter.bookmarksPage,  builder: (_, __) => const BookmarksPage()),
        GoRoute(path: AppRouter.chatPage,       builder: (_, __) => const ChatListPage()),
        GoRoute(path: AppRouter.profilePage,    builder: (_, __) => const ProfilePage()),
        GoRoute(path: AppRouter.editProfilePage, builder: (_, __) => const EditProfilePage()),
        GoRoute(
          path: '/jobs',
          builder: (ctx, state) => JobsListPage(title: state.extra as String?),
        ),
        GoRoute(
          path: '/jobs/:id',
          builder: (ctx, state) => ChangeNotifierProvider<JobDetailsProvider>(
            create: (_) => JobDetailsProvider(),
            child: JobDetailsPage(job: state.extra as JobModel),
          ),
        ),
        GoRoute(path: AppRouter.conversationPage, builder: (_, __) => const ConversationPage()),
      ],
    ),
  ],
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
