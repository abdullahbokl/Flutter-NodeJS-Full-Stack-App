import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jobhub_flutter/core/common/bloc/theme_cubit.dart';
import 'package:jobhub_flutter/core/config/app_setup.dart';
import 'package:jobhub_flutter/core/services/api_services.dart';
import 'package:jobhub_flutter/core/theme/app_theme.dart';
import 'package:jobhub_flutter/core/utils/app_session.dart';
import 'package:jobhub_flutter/features/auth/presentation/bloc/login_cubit.dart';
import 'package:jobhub_flutter/features/splash/presentation/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await AppSetup.resetForTest();
  });

  tearDown(() async {
    await AppSetup.resetForTest();
  });

  test('prepareForFirstFrame restores cached session without deferred graph',
      () async {
    SharedPreferences.setMockInitialValues({
      'token': _jwt(userId: 'user-1', role: 'company'),
      'role': 'company',
    });

    await AppSetup.prepareForFirstFrame();

    expect(getIt.isRegistered<SharedPreferences>(), isTrue);
    expect(getIt.isRegistered<ThemeCubit>(), isTrue);
    expect(getIt.isRegistered<ApiServices>(), isFalse);
    expect(getIt.isRegistered<LoginCubit>(), isFalse);
    expect(AppSession.isAuthenticated, isTrue);
    expect(AppSession.role, 'company');
    expect(AppSession.userId, isEmpty);
  });

  test('completeDeferredBootstrap hydrates user id and marks startup ready',
      () async {
    SharedPreferences.setMockInitialValues({
      'token': _jwt(userId: 'user-42', role: 'seeker'),
      'role': 'seeker',
    });

    await AppSetup.prepareForFirstFrame();
    await AppSetup.completeDeferredBootstrap();

    expect(getIt.isRegistered<ApiServices>(), isTrue);
    expect(getIt.isRegistered<LoginCubit>(), isTrue);
    expect(AppSession.userId, 'user-42');
    expect(
      AppSetup.bootstrapReadiness.value,
      AppBootstrapReadiness.ready,
    );
  });

  testWidgets(
      'splash renders immediately and navigates after deferred bootstrap',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'isFirstTime': false,
    });

    await AppSetup.prepareForFirstFrame();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (_, __) => const Scaffold(body: Text('Login Screen')),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) => const Scaffold(body: Text('Onboarding Screen')),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('Home Screen')),
        ),
        GoRoute(
          path: '/company/dashboard',
          builder: (_, __) => const Scaffold(body: Text('Company Screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );

    expect(find.text('Job Hub'), findsOneWidget);
    expect(find.text('Login Screen'), findsNothing);

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
    expect(
      AppSetup.bootstrapReadiness.value,
      AppBootstrapReadiness.ready,
    );
  });
}

String _jwt({
  required String userId,
  required String role,
}) {
  final header = _base64UrlEncode({'alg': 'HS256', 'typ': 'JWT'});
  final payload = _base64UrlEncode({
    'id': userId,
    'role': role,
    'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
  });
  return '$header.$payload.signature';
}

String _base64UrlEncode(Map<String, Object> value) {
  return base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
}
