import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobhub_flutter/core/common/base_state.dart';
import 'package:jobhub_flutter/core/common/models/user_model.dart';
import 'package:jobhub_flutter/features/chat/data/models/message_model.dart';
import 'package:jobhub_flutter/features/chat/data/repositories/chat_repo.dart';
import 'package:jobhub_flutter/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:jobhub_flutter/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:jobhub_flutter/features/chat/presentation/bloc/chat_sync_service.dart';
import 'package:jobhub_flutter/features/chat/presentation/bloc/messages_cubit.dart';
import 'package:jobhub_flutter/features/jobs/data/repositories/jobs_repo.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/job_entity.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/job_filter_params.dart';
import 'package:jobhub_flutter/features/jobs/domain/entities/paginated_jobs_result.dart';
import 'package:jobhub_flutter/features/jobs/domain/usecases/get_jobs_usecase.dart';
import 'package:jobhub_flutter/features/jobs/presentation/bloc/jobs_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepo extends Mock implements ChatRepo {}

class MockJobsRepo extends Mock implements JobsRepo {}

class FakeJobFilterParams extends Fake implements JobFilterParams {}

void main() {
  late MockChatRepo chatRepo;
  late MockJobsRepo jobsRepo;
  late ChatSyncService chatSyncService;

  const sender = UserModel(
    id: 'user-1',
    email: 'user@example.com',
    userName: 'user',
  );
  const message = MessageModel(
    id: 'message-1',
    sender: sender,
    content: 'Hello there',
    createdAt: '2025-01-01T10:00:00.000Z',
  );
  const pageOneJob = JobEntity(
    id: 'job-1',
    title: 'Flutter Engineer',
    description: 'Build polished Flutter apps',
    location: 'Remote',
    salary: '5000',
    company: 'Job Hub',
    period: 'Monthly',
    contract: 'Full-time',
    requirements: ['Flutter'],
    agentId: 'agent-1',
  );
  const pageTwoJob = JobEntity(
    id: 'job-2',
    title: 'Mobile Product Designer',
    description: 'Shape mobile experiences',
    location: 'Onsite',
    salary: '4500',
    company: 'Job Hub',
    period: 'Monthly',
    contract: 'Part-time',
    requirements: ['Design'],
    agentId: 'agent-2',
  );

  setUpAll(() {
    registerFallbackValue(FakeJobFilterParams());
  });

  setUp(() {
    chatRepo = MockChatRepo();
    jobsRepo = MockJobsRepo();
    chatSyncService = ChatSyncService();
  });

  tearDown(() async {
    await chatSyncService.dispose();
  });

  test('typing notifier updates without re-emitting message states', () async {
    when(() => chatRepo.getMessages('chat-1'))
        .thenAnswer((_) async => const [message]);

    final cubit = MessagesCubit(
      getMessages: GetMessagesUseCase(chatRepo),
      sendMessageUseCase: SendMessageUseCase(chatRepo),
      chatSyncService: chatSyncService,
    );
    addTearDown(cubit.close);

    final emittedStates = <BaseState<List<MessageModel>>>[];
    final subscription = cubit.stream.listen(emittedStates.add);
    addTearDown(subscription.cancel);

    await cubit.loadMessages('chat-1');
    cubit.debugSetTyping(true);
    await Future<void>.delayed(Duration.zero);

    expect(
      emittedStates,
      const <BaseState<List<MessageModel>>>[
        LoadingState<List<MessageModel>>(),
        SuccessState<List<MessageModel>>([message]),
      ],
    );
    expect(cubit.typingListenable.value, isTrue);
  });

  blocTest<JobsCubit, BaseState<List<JobEntity>>>(
    'search keeps debounced query behavior and loads filtered results',
    build: () {
      when(() => jobsRepo.getAllJobs(filters: any(named: 'filters')))
          .thenAnswer(
        (invocation) async {
          final filters =
              invocation.namedArguments[#filters] as JobFilterParams;
          if (filters.query == 'flutter') {
            return const PaginatedJobsResult(
              jobs: [pageOneJob],
              page: 1,
              limit: 10,
              total: 1,
              totalPages: 1,
            );
          }

          return const PaginatedJobsResult(
            jobs: [],
            page: 1,
            limit: 10,
            total: 0,
            totalPages: 1,
          );
        },
      );

      return JobsCubit(GetJobsUseCase(jobsRepo));
    },
    act: (cubit) => cubit.search('flutter'),
    wait: const Duration(milliseconds: 400),
    expect: () => const <BaseState<List<JobEntity>>>[
      LoadingState<List<JobEntity>>(),
      SuccessState<List<JobEntity>>([pageOneJob]),
    ],
    verify: (cubit) {
      expect(cubit.filters.query, 'flutter');
      expect(cubit.jobs, const [pageOneJob]);
    },
  );

  blocTest<JobsCubit, BaseState<List<JobEntity>>>(
    'loadMore appends the next page and preserves pagination state',
    build: () {
      when(() => jobsRepo.getAllJobs(filters: any(named: 'filters')))
          .thenAnswer(
        (invocation) async {
          final filters =
              invocation.namedArguments[#filters] as JobFilterParams;
          if (filters.page == 2) {
            return const PaginatedJobsResult(
              jobs: [pageTwoJob],
              page: 2,
              limit: 10,
              total: 2,
              totalPages: 2,
            );
          }

          return const PaginatedJobsResult(
            jobs: [pageOneJob],
            page: 1,
            limit: 10,
            total: 2,
            totalPages: 2,
          );
        },
      );

      return JobsCubit(GetJobsUseCase(jobsRepo));
    },
    act: (cubit) async {
      await cubit.loadJobs();
      await cubit.loadMore();
    },
    expect: () => const <BaseState<List<JobEntity>>>[
      LoadingState<List<JobEntity>>(),
      SuccessState<List<JobEntity>>([pageOneJob]),
      SuccessState<List<JobEntity>>([pageOneJob, pageTwoJob]),
    ],
    verify: (cubit) {
      expect(cubit.jobs, const [pageOneJob, pageTwoJob]);
      expect(cubit.hasMore, isFalse);
    },
  );
}
