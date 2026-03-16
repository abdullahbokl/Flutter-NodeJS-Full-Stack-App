import 'package:go_router/go_router.dart';
export 'router/app_route_paths.dart';

import 'package:flutter/material.dart';

import 'router/app_route_groups.dart';
import 'router/app_route_paths.dart';
import 'router/app_route_redirector.dart';

/// GoRouter instance used by [MyApp].
final GoRouter appRouter = GoRouter(
  initialLocation: AppRouter.splash,
  redirect: (_, state) => const AppRouteRedirector().redirect(state),
  routes: buildAppRoutes(),
  errorBuilder: (ctx, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
