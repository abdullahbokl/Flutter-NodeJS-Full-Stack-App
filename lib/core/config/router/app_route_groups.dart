import 'package:go_router/go_router.dart';

import 'groups/auth_route_group.dart';
import 'groups/detail_route_group.dart';
import 'groups/profile_route_group.dart';
import 'groups/shell_route_group.dart';

List<RouteBase> buildAppRoutes() {
  return [
    ...buildAuthRoutes(),
    buildShellRoutes(),
    buildProfileRoutes(),
    ...buildDetailRoutes(),
  ];
}
