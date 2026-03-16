import 'package:go_router/go_router.dart';

T? routeExtraOrNull<T>(GoRouterState state) {
  final extra = state.extra;
  if (extra is T) {
    return extra;
  }
  return null;
}

String requiredPathParameter(GoRouterState state, String name) {
  final value = state.pathParameters[name];
  if (value == null || value.isEmpty) {
    throw ArgumentError('Missing path parameter: $name');
  }
  return value;
}
