import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user_role.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../features/chat/data/models/chat_model.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/conversation_page.dart';
import '../../features/home/presentation/pages/company_dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/jobs/domain/entities/job_entity.dart';
import '../../features/jobs/presentation/pages/job_details_page.dart';
import '../../features/jobs/presentation/pages/jobs_list_page.dart';
import '../../features/on_boarding/presentation/on_boarding_screen.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../common/widgets/drawer/drawer_screen.dart';
import '../utils/app_session.dart';
import 'app_setup.dart';

class AppRouter {
  static const String onBoarding = '/';
  static const String loginPage = '/login';
  static const String roleSelectionPage = '/register';
  static const String registerPage = '/register/:role';
  static const String homePage = '/home';
  static const String companyDashboardPage = '/company/dashboard';
  static const String searchPage = '/search';
  static const String bookmarksPage = '/bookmarks';
  static const String chatPage = '/chat';
  static const String profilePage = '/profile';
  static const String editProfilePage = '/profile/edit';
  static const String jobsListPage = '/jobs';
  static const String jobDetailsPage = '/jobs/:id';
  static const String chatDetailPage = '/chat/:id';
}


/// GoRouter instance used by [MyApp].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.onBoarding,
  redirect: (context, state) {
    final prefs = getIt<SharedPreferences>();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final isLoggedIn = AppSession.isAuthenticated;
    final location = state.matchedLocation;

    // If the user is authenticated, skip onboarding & login → go to appropriate home
    if (isLoggedIn) {
      if (location == AppRouter.onBoarding ||
          location == AppRouter.loginPage ||
          location == AppRouter.roleSelectionPage ||
          location.startsWith('/register/')) {
        return AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage;
      }
      return null; // stay on current route
    }

    // Not authenticated — if onboarding finished, show login
    if (!isFirstTime && location == AppRouter.onBoarding) {
      return AppRouter.loginPage;
    }

    return null;
  },
  routes: [
    // ─── Auth / Onboarding (no shell) ───────────────────────────────────────
    GoRoute(
      path: AppRouter.onBoarding,
      builder: (_, __) => const OnBoardingScreen(),
    ),
    GoRoute(path: AppRouter.loginPage, builder: (_, __) => const LoginPage()),
    GoRoute(
        path: AppRouter.roleSelectionPage,
        builder: (_, __) => const RoleSelectionPage()),
    GoRoute(
      path: AppRouter.registerPage,
      builder: (ctx, state) {
        final roleStr = state.pathParameters['role'] ?? 'seeker';
        final role = UserRole.fromString(roleStr);
        return RegisterPage(role: role);
      },
    ),

    // ─── Shell (drawer + persistent tabs) ───────────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) => DrawerScreen(child: child),
      routes: [
        GoRoute(
            path: AppRouter.homePage, builder: (_, __) => const HomePage()),
        GoRoute(
          path: AppRouter.companyDashboardPage,
          builder: (_, __) => const CompanyDashboardPage(),
        ),
        GoRoute(
            path: AppRouter.searchPage, builder: (_, __) => const SearchPage()),
        GoRoute(
            path: AppRouter.bookmarksPage,
            builder: (_, __) => const BookmarksPage()),
        GoRoute(
            path: AppRouter.chatPage, builder: (_, __) => const ChatListPage()),
        GoRoute(
          path: '/jobs',
          builder: (ctx, state) => JobsListPage(title: state.extra as String?),
        ),
      ],
    ),

    // ─── Detail pages — pushed on top of shell, always poppable ────────────

    // Profile pages share a single ProfileCubit instance
    ShellRoute(
      builder: (ctx, state, child) => BlocProvider<ProfileCubit>(
        create: (_) => getIt<ProfileCubit>()..loadProfile(),
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRouter.profilePage,
          builder: (_, __) => const ProfilePage(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (_, __) => const EditProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // /jobs/:id
    GoRoute(
      path: '/jobs/:id',
      builder: (ctx, state) =>
          JobDetailsPage.page(job: state.extra as JobEntity),
    ),

    // /chat/:id
    GoRoute(
      path: '/chat/:id',
      builder: (ctx, state) => ConversationPage(chat: state.extra as ChatModel?),
    ),
  ],
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);

