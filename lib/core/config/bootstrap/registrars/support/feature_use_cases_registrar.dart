import '../../../service_locator.dart';
import '../../../../../features/applications/data/repositories/applications_repo.dart';
import '../../../../../features/applications/domain/usecases/apply_for_job_usecase.dart';
import '../../../../../features/applications/domain/usecases/get_my_applications_usecase.dart';
import '../../../../../features/applications/domain/usecases/get_received_applications_usecase.dart';
import '../../../../../features/applications/domain/usecases/update_application_status_usecase.dart';
import '../../../../../features/auth/data/repositories/user_repo/user_repo.dart';
import '../../../../../features/bookmarks/data/repositories/bookmarks_repo.dart';
import '../../../../../features/bookmarks/domain/usecases/add_bookmark_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/check_bookmark_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import '../../../../../features/bookmarks/domain/usecases/remove_bookmark_usecase.dart';
import '../../../../../features/chat/data/repositories/chat_repo.dart';
import '../../../../../features/chat/domain/usecases/create_or_get_chat_usecase.dart';
import '../../../../../features/chat/domain/usecases/get_chats_usecase.dart';
import '../../../../../features/chat/domain/usecases/get_messages_usecase.dart';
import '../../../../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../../../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../../../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../../../../features/search/data/repositories/search_repo.dart';
import '../../../../../features/search/domain/usecases/search_jobs_usecase.dart';

void registerFeatureUseCases() {
  serviceLocator.registerLazySingleton<SearchJobsUseCase>(
    () => SearchJobsUseCase(serviceLocator<SearchRepo>()),
  );
  serviceLocator.registerLazySingleton<GetBookmarksUseCase>(
    () => GetBookmarksUseCase(serviceLocator<BookmarksRepo>()),
  );
  serviceLocator.registerLazySingleton<AddBookmarkUseCase>(
    () => AddBookmarkUseCase(serviceLocator<BookmarksRepo>()),
  );
  serviceLocator.registerLazySingleton<RemoveBookmarkUseCase>(
    () => RemoveBookmarkUseCase(serviceLocator<BookmarksRepo>()),
  );
  serviceLocator.registerLazySingleton<CheckBookmarkUseCase>(
    () => CheckBookmarkUseCase(serviceLocator<BookmarksRepo>()),
  );
  serviceLocator.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(serviceLocator<UserRepo>()),
  );
  serviceLocator.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(serviceLocator<UserRepo>()),
  );
  serviceLocator.registerLazySingleton<GetChatsUseCase>(
    () => GetChatsUseCase(serviceLocator<ChatRepo>()),
  );
  serviceLocator.registerLazySingleton<CreateOrGetChatUseCase>(
    () => CreateOrGetChatUseCase(serviceLocator<ChatRepo>()),
  );
  serviceLocator.registerLazySingleton<GetMessagesUseCase>(
    () => GetMessagesUseCase(serviceLocator<ChatRepo>()),
  );
  serviceLocator.registerLazySingleton<SendMessageUseCase>(
    () => SendMessageUseCase(serviceLocator<ChatRepo>()),
  );
  serviceLocator.registerLazySingleton<ApplyForJobUseCase>(
    () => ApplyForJobUseCase(serviceLocator<ApplicationsRepo>()),
  );
  serviceLocator.registerLazySingleton<GetMyApplicationsUseCase>(
    () => GetMyApplicationsUseCase(serviceLocator<ApplicationsRepo>()),
  );
  serviceLocator.registerLazySingleton<GetReceivedApplicationsUseCase>(
    () => GetReceivedApplicationsUseCase(serviceLocator<ApplicationsRepo>()),
  );
  serviceLocator.registerLazySingleton<UpdateApplicationStatusUseCase>(
    () => UpdateApplicationStatusUseCase(serviceLocator<ApplicationsRepo>()),
  );
}
