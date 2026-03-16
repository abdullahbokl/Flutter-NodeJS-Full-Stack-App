import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';
import '../../../utils/app_session.dart';
import '../../service_locator.dart';
import '../app_route_paths.dart';

RouteBase buildProfileRoutes() {
  return ShellRoute(
    builder: (_, __, child) => BlocProvider<ProfileCubit>(
      create: (_) {
        final cubit = serviceLocator<ProfileCubit>();
        if (AppSession.isAuthenticated) {
          cubit.loadProfile();
        }
        return cubit;
      },
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
  );
}
