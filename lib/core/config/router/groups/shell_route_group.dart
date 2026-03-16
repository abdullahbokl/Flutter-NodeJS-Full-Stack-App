import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/applications/presentation/bloc/application_action_cubit.dart';
import '../../../../features/applications/presentation/bloc/my_applications_cubit.dart';
import '../../../../features/applications/presentation/bloc/received_applications_cubit.dart';
import '../../../../features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import '../../../../features/bookmarks/presentation/pages/bookmarks_page.dart';
import '../../../../features/chat/presentation/pages/chat_list_page.dart';
import '../../../../features/home/presentation/bloc/home_cubit.dart';
import '../../../../features/home/presentation/pages/company_applications_page.dart';
import '../../../../features/home/presentation/pages/company_dashboard_page.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/home/presentation/pages/my_applications_page.dart';
import '../../../../features/jobs/presentation/bloc/jobs_cubit.dart';
import '../../../../features/jobs/presentation/bloc/manage_job_action_cubit.dart';
import '../../../../features/jobs/presentation/bloc/manage_jobs_cubit.dart';
import '../../../../features/jobs/presentation/pages/jobs_list_page.dart';
import '../../service_locator.dart';
import '../app_route_helpers.dart';
import '../app_route_paths.dart';

RouteBase buildShellRoutes() {
  return ShellRoute(
    builder: (_, __, child) => child,
    routes: [
      GoRoute(
        path: AppRouter.homePage,
        builder: (_, __) => BlocProvider<HomeCubit>(
          create: (_) => serviceLocator<HomeCubit>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRouter.companyDashboardPage,
        builder: (_, __) => const CompanyDashboardPage(),
      ),
      GoRoute(
        path: AppRouter.searchPage,
        builder: (_, __) => BlocProvider<JobsCubit>(
          create: (_) => serviceLocator<JobsCubit>(),
          child: const JobsListPage(
            title: 'All Jobs',
            autofocusSearch: true,
          ),
        ),
      ),
      GoRoute(
        path: AppRouter.bookmarksPage,
        builder: (_, __) => BlocProvider<BookmarksCubit>(
          create: (_) => serviceLocator<BookmarksCubit>(),
          child: const BookmarksPage(),
        ),
      ),
      GoRoute(
        path: AppRouter.chatPage,
        builder: (_, __) => const ChatListPage(),
      ),
      GoRoute(
        path: AppRouter.jobsListPage,
        builder: (_, state) => BlocProvider<JobsCubit>(
          create: (_) => serviceLocator<JobsCubit>(),
          child: JobsListPage(title: routeExtraOrNull<String>(state)),
        ),
      ),
      GoRoute(
        path: AppRouter.manageJobsPage,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<ManageJobsCubit>(
              create: (_) => serviceLocator<ManageJobsCubit>()..loadMyJobs(),
            ),
            BlocProvider<ManageJobActionCubit>(
              create: (_) => serviceLocator<ManageJobActionCubit>(),
            ),
          ],
          child: const JobsListPage(
            title: 'My Posted Jobs',
            isMine: true,
          ),
        ),
      ),
      GoRoute(
        path: AppRouter.companyApplicationsPage,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider<ReceivedApplicationsCubit>(
              create: (_) => serviceLocator<ReceivedApplicationsCubit>()
                ..loadApplications(),
            ),
            BlocProvider<ApplicationActionCubit>(
              create: (_) => serviceLocator<ApplicationActionCubit>(),
            ),
          ],
          child: const CompanyApplicationsPage(),
        ),
      ),
      GoRoute(
        path: AppRouter.myApplicationsPage,
        builder: (_, __) => BlocProvider<MyApplicationsCubit>(
          create: (_) =>
              serviceLocator<MyApplicationsCubit>()..loadApplications(),
          child: const MyApplicationsPage(),
        ),
      ),
    ],
  );
}
