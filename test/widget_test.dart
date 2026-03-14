import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobhub_flutter/core/common/widgets/premium_ui.dart';
import 'package:jobhub_flutter/core/theme/app_theme.dart';
import 'package:jobhub_flutter/features/auth/presentation/pages/role_selection_page.dart';

void main() {
  testWidgets('role selection renders redesigned entry choices', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const RoleSelectionPage(),
      ),
    );

    expect(find.text('Job Seeker'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);
    expect(find.byType(GlassPanel), findsWidgets);
  });

  testWidgets('premium scaffold renders glow background and child content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const PremiumScaffold(
          child: Center(child: Text('Hello Job Hub')),
        ),
      ),
    );

    expect(find.text('Hello Job Hub'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
