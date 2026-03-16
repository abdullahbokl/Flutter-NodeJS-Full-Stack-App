import '../../../service_locator.dart';
import '../../../../../features/applications/domain/usecases/apply_for_job_usecase.dart';
import '../../../../../features/applications/domain/usecases/get_my_applications_usecase.dart';
import '../../../../../features/applications/domain/usecases/get_received_applications_usecase.dart';
import '../../../../../features/applications/domain/usecases/update_application_status_usecase.dart';
import '../../../../../features/applications/presentation/bloc/application_action_cubit.dart';
import '../../../../../features/applications/presentation/bloc/my_applications_cubit.dart';
import '../../../../../features/applications/presentation/bloc/received_applications_cubit.dart';
import '../../../../../features/bookmarks/domain/usecases/add_bookmark_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/check_bookmark_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/remove_bookmark_usecase.dart';
import '../../../../../features/bookmarks/presentation/bloc/bookmark_status_cubit.dart';
import '../../../../../features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import '../../../../../features/chat/domain/usecases/create_or_get_chat_usecase.dart';
import '../../../../../features/chat/domain/usecases/get_chats_usecase.dart';
import '../../../../../features/chat/domain/usecases/get_messages_usecase.dart';
import '../../../../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../../../../features/chat/presentation/bloc/chat_cubit.dart';
import '../../../../../features/chat/presentation/bloc/chat_sync_service.dart';
import '../../../../../features/chat/presentation/bloc/messages_cubit.dart';
import '../../../../../features/home/domain/usecases/get_home_jobs_usecase.dart';
import '../../../../../features/home/presentation/bloc/home_cubit.dart';
import '../../../../../features/jobs/domain/usecases/create_job_usecase.dart';
import '../../../../../features/jobs/domain/usecases/delete_job_usecase.dart';
import '../../../../../features/jobs/domain/usecases/get_jobs_usecase.dart';
import '../../../../../features/jobs/domain/usecases/get_my_jobs_usecase.dart';
import '../../../../../features/jobs/domain/usecases/update_job_usecase.dart';
import '../../../../../features/jobs/presentation/bloc/jobs_cubit.dart';
import '../../../../../features/jobs/presentation/bloc/manage_job_action_cubit.dart';
import '../../../../../features/jobs/presentation/bloc/manage_jobs_cubit.dart';
import '../../../../../features/jobs/presentation/bloc/post_job_cubit.dart';
import '../../../../../features/search/domain/usecases/search_jobs_usecase.dart';
import '../../../../../features/search/presentation/bloc/search_cubit.dart';

void registerFeatureCubits() {
  serviceLocator.registerFactory<HomeCubit>(
    () => HomeCubit(serviceLocator<GetHomeJobsUseCase>()),
  );
  serviceLocator.registerFactory<JobsCubit>(
    () => JobsCubit(serviceLocator<GetJobsUseCase>()),
  );
  serviceLocator.registerFactory<PostJobCubit>(
    () => PostJobCubit(
      serviceLocator<CreateJobUseCase>(),
      serviceLocator<UpdateJobUseCase>(),
    ),
  );
  serviceLocator.registerFactory<ManageJobsCubit>(
    () => ManageJobsCubit(serviceLocator<GetMyJobsUseCase>()),
  );
  serviceLocator.registerFactory<ManageJobActionCubit>(
    () => ManageJobActionCubit(
      updateJob: serviceLocator<UpdateJobUseCase>(),
      deleteJob: serviceLocator<DeleteJobUseCase>(),
    ),
  );
  serviceLocator.registerFactory<SearchCubit>(
    () => SearchCubit(serviceLocator<SearchJobsUseCase>()),
  );
  serviceLocator.registerFactory<BookmarksCubit>(
    () => BookmarksCubit(
      getBookmarksUseCase: serviceLocator<GetBookmarksUseCase>(),
      addBookmarkUseCase: serviceLocator<AddBookmarkUseCase>(),
      removeBookmarkUseCase: serviceLocator<RemoveBookmarkUseCase>(),
    ),
  );
  serviceLocator.registerFactory<BookmarkStatusCubit>(
    () => BookmarkStatusCubit(
      checkBookmark: serviceLocator<CheckBookmarkUseCase>(),
      addBookmark: serviceLocator<AddBookmarkUseCase>(),
      removeBookmark: serviceLocator<RemoveBookmarkUseCase>(),
    ),
  );
  serviceLocator.registerFactory<ChatCubit>(
    () => ChatCubit(
      getChats: serviceLocator<GetChatsUseCase>(),
      createOrGetChat: serviceLocator<CreateOrGetChatUseCase>(),
      chatSyncService: serviceLocator<ChatSyncService>(),
    ),
  );
  serviceLocator.registerFactory<MessagesCubit>(
    () => MessagesCubit(
      getMessages: serviceLocator<GetMessagesUseCase>(),
      sendMessageUseCase: serviceLocator<SendMessageUseCase>(),
      chatSyncService: serviceLocator<ChatSyncService>(),
    ),
  );
  serviceLocator.registerFactory<MyApplicationsCubit>(
    () => MyApplicationsCubit(serviceLocator<GetMyApplicationsUseCase>()),
  );
  serviceLocator.registerFactory<ReceivedApplicationsCubit>(
    () => ReceivedApplicationsCubit(
      serviceLocator<GetReceivedApplicationsUseCase>(),
    ),
  );
  serviceLocator.registerFactory<ApplicationActionCubit>(
    () => ApplicationActionCubit(
      applyForJob: serviceLocator<ApplyForJobUseCase>(),
      updateStatus: serviceLocator<UpdateApplicationStatusUseCase>(),
    ),
  );
}
