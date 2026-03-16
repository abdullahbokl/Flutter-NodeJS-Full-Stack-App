import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobhub_flutter/core/common/models/job_model.dart';
import 'package:jobhub_flutter/core/common/widgets/app_chip.dart';
import 'package:jobhub_flutter/core/common/widgets/premium_ui.dart';
import 'package:jobhub_flutter/core/theme/app_theme.dart';
import 'package:jobhub_flutter/features/auth/presentation/pages/role_selection_page.dart';
import 'package:jobhub_flutter/features/home/domain/usecases/get_home_jobs_usecase.dart';
import 'package:jobhub_flutter/features/home/presentation/bloc/home_cubit.dart';
import 'package:jobhub_flutter/features/home/presentation/pages/home_page.dart';
import 'package:jobhub_flutter/features/jobs/data/repositories/jobs_repo.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/job_entity.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/job_filter_params.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/paginated_jobs_result.dart';
import 'package:jobhub_flutter/features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'package:jobhub_flutter/features/jobs/presentation/bloc/jobs_cubit.dart';
import 'package:jobhub_flutter/features/jobs/presentation/pages/jobs_list_page.dart';
import 'package:mocktail/mocktail.dart';

class MockJobsRepo extends Mock implements JobsRepo {}

class FakeJobFilterParams extends Fake implements JobFilterParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeJobFilterParams());
  });

  testWidgets('role selection renders wide layout without intrinsic sizing',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1200, 900));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const RoleSelectionPage(),
      ),
    );

    expect(find.text('Job Seeker'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);
    expect(find.byType(GlassPanel), findsWidgets);
    expect(find.byType(IntrinsicHeight), findsNothing);
  });

  testWidgets('premium scaffold renders glow background and child content',
      (tester) async {
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

  testWidgets('home filter only rebuilds the recent jobs section behaviorally',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(1200, 2200));

    final repo = MockJobsRepo();
    final remoteJob = _jobModel(
      id: 'remote-1',
      title: 'Remote Flutter Engineer',
      location: 'Remote',
      contract: 'Full-time',
    );
    final onsiteJob = _jobModel(
      id: 'onsite-1',
      title: 'Onsite Product Designer',
      location: 'Onsite',
      contract: 'Part-time',
    );

    when(() => repo.getAllJobs()).thenAnswer(
      (_) async => PaginatedJobsResult(
        jobs: [remoteJob, onsiteJob],
        page: 1,
        limit: 10,
        total: 2,
        totalPages: 1,
      ),
    );

    final cubit = HomeCubit(GetHomeJobsUseCase(repo));
    addTearDown(cubit.close);
    await cubit.loadJobs();

    await tester.pumpWidget(
      BlocProvider<HomeCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const HomePage(),
        ),
      ),
    );

    expect(find.text('Remote Flutter Engineer'), findsNWidgets(2));
    expect(find.text('Onsite Product Designer'), findsNWidgets(2));

    await tester.tap(find.widgetWithText(AppChip, 'Remote'));
    await tester.pump();

    expect(find.text('Remote Flutter Engineer'), findsNWidgets(2));
    expect(find.text('Onsite Product Designer'), findsOneWidget);
  });

  testWidgets('jobs browse search shows clear action and opens filters',
      (tester) async {
    final repo = MockJobsRepo();
    when(() => repo.getAllJobs(filters: any(named: 'filters'))).thenAnswer(
      (invocation) async {
        final filters = invocation.namedArguments[#filters] as JobFilterParams;
        return PaginatedJobsResult(
          jobs: const <JobEntity>[],
          page: filters.page,
          limit: filters.limit,
          total: 0,
          totalPages: 1,
        );
      },
    );

    final cubit = JobsCubit(GetJobsUseCase(repo));
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider<JobsCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const JobsListPage(title: 'All Jobs'),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, 'flutter');
    await tester.pump();

    expect(find.byIcon(Icons.clear_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Filter Jobs'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pump();

    final searchField = tester.widget<TextField>(find.byType(TextField).first);
    expect(searchField.controller?.text, isEmpty);
  });
}

JobModel _jobModel({
  required String id,
  required String title,
  required String location,
  required String contract,
}) {
  return JobModel(
    id: id,
    title: title,
    description: '$title description',
    location: location,
    salary: '5000',
    company: 'Job Hub',
    period: 'Monthly',
    contract: contract,
    requirements: const ['Flutter'],
    agentId: 'agent-1',
  );
}
