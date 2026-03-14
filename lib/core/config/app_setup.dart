import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/login_cubit.dart';
import '../../features/auth/presentation/bloc/register_cubit.dart';
import '../../features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import '../../features/auth/data/repositories/user_repo/user_repo.dart';
import '../../features/auth/data/repositories/user_repo/user_repo_impl.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repo_impl.dart';
import '../../features/bookmarks/data/repositories/bookmarks_repo.dart';
import '../../features/bookmarks/domain/usecases/add_bookmark_usecase.dart';
import '../../features/bookmarks/domain/usecases/check_bookmark_usecase.dart';
import '../../features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import '../../features/bookmarks/domain/usecases/remove_bookmark_usecase.dart';
import '../../features/bookmarks/presentation/bloc/bookmark_status_cubit.dart';
import '../../features/bookmarks/presentation/bloc/bookmarks_cubit.dart';
import '../../features/applications/data/repositories/applications_repo.dart';
import '../../features/applications/data/repositories/applications_repo_impl.dart';
import '../../features/applications/domain/usecases/apply_for_job_usecase.dart';
import '../../features/applications/domain/usecases/get_my_applications_usecase.dart';
import '../../features/applications/domain/usecases/get_received_applications_usecase.dart';
import '../../features/applications/domain/usecases/update_application_status_usecase.dart';
import '../../features/applications/presentation/bloc/application_action_cubit.dart';
import '../../features/applications/presentation/bloc/my_applications_cubit.dart';
import '../../features/applications/presentation/bloc/received_applications_cubit.dart';
import '../../features/chat/data/repositories/chat_repo_impl.dart';
import '../../features/chat/data/repositories/chat_repo.dart';
import '../../features/chat/domain/usecases/create_or_get_chat_usecase.dart';
import '../../features/chat/domain/usecases/get_chats_usecase.dart';
import '../../features/chat/domain/usecases/get_messages_usecase.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/presentation/bloc/chat_cubit.dart';
import '../../features/chat/presentation/bloc/chat_sync_service.dart';
import '../../features/chat/presentation/bloc/messages_cubit.dart';
import '../../features/home/domain/usecases/get_home_jobs_usecase.dart';
import '../../features/home/presentation/bloc/home_cubit.dart';
import '../../features/jobs/data/repositories/jobs_repo_impl.dart';
import '../../features/jobs/data/repositories/jobs_repo.dart';
import '../../features/jobs/domain/usecases/get_jobs_usecase.dart';
import '../../features/jobs/domain/usecases/create_job_usecase.dart';
import '../../features/jobs/domain/usecases/get_my_jobs_usecase.dart';
import '../../features/jobs/domain/usecases/update_job_usecase.dart';
import '../../features/jobs/domain/usecases/delete_job_usecase.dart';
import '../../features/jobs/presentation/bloc/jobs_cubit.dart';
import '../../features/jobs/presentation/bloc/post_job_cubit.dart';
import '../../features/jobs/presentation/bloc/manage_job_action_cubit.dart';
import '../../features/jobs/presentation/bloc/manage_jobs_cubit.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../features/search/data/repositories/search_repo_impl.dart';
import '../../features/search/data/repositories/search_repo.dart';
import '../../features/search/domain/usecases/search_jobs_usecase.dart';
import '../../features/search/presentation/bloc/search_cubit.dart';
import '../common/bloc/theme_cubit.dart';
import '../services/api_services.dart';
import '../services/auth_interceptor.dart';
import '../services/logger.dart';
import '../utils/app_session.dart';
import 'app_config.dart';
final GetIt getIt = GetIt.instance;
class AppSetup {
  static Future<void> setupServiceLocator() async {
    await _registerInfrastructure();
    await _registerRepositories();
    _registerUseCases();
    _registerCubits();
    _logEvent("All dependencies registered");
  }
  static Future<void> _registerInfrastructure() async {
    // Shared preferences
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
    getIt.registerLazySingleton<ThemeCubit>(
      () => ThemeCubit(getIt<SharedPreferences>()),
    );
    // Dio with AuthInterceptor (no hardcoded token in BaseOptions)
    getIt.registerLazySingleton<Dio>(() {
      _logEvent(
        "Configuring Dio | baseUrl=${AppConfig.instance.baseUrl} | socketUrl=${AppConfig.instance.socketUrl}",
      );
      return Dio(
        BaseOptions(
          baseUrl: AppConfig.instance.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        ),
      )
        ..interceptors.add(AuthInterceptor())
        ..interceptors.add(LogInterceptor(requestBody: true, responseBody: false));
    });
    getIt.registerLazySingleton<ApiServices>(() => ApiServices(getIt<Dio>()));
    getIt.registerLazySingleton<ChatSyncService>(() => ChatSyncService());
  }
  static Future<void> _registerRepositories() async {
    getIt.registerLazySingleton<AuthRepoImpl>(() => AuthRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<UserRepoImpl>(() => UserRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<SearchRepoImpl>(() => SearchRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<JobsRepoImpl>(() => JobsRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<BookmarksRepoImpl>(() => BookmarksRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<ChatRepoImpl>(() => ChatRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<ApplicationsRepoImpl>(() => ApplicationsRepoImpl(getIt<ApiServices>()));
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt<AuthRepoImpl>()),
    );
    getIt.registerLazySingleton<UserRepo>(() => getIt<UserRepoImpl>());
    getIt.registerLazySingleton<SearchRepo>(() => getIt<SearchRepoImpl>());
    getIt.registerLazySingleton<JobsRepo>(() => getIt<JobsRepoImpl>());
    getIt.registerLazySingleton<BookmarksRepo>(() => getIt<BookmarksRepoImpl>());
    getIt.registerLazySingleton<ChatRepo>(() => getIt<ChatRepoImpl>());
    getIt.registerLazySingleton<ApplicationsRepo>(() => getIt<ApplicationsRepoImpl>());
  }
  static void _registerUseCases() {
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
    getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(getIt<AuthRepository>()),
    );
    getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
    getIt.registerLazySingleton<GetHomeJobsUseCase>(
      () => GetHomeJobsUseCase(getIt<JobsRepo>()),
    );
    getIt.registerLazySingleton<GetJobsUseCase>(
      () => GetJobsUseCase(getIt<JobsRepo>()),
    );
    getIt.registerLazySingleton<CreateJobUseCase>(
      () => CreateJobUseCase(getIt<JobsRepo>()),
    );
    getIt.registerLazySingleton<GetMyJobsUseCase>(
      () => GetMyJobsUseCase(getIt<JobsRepo>()),
    );
    getIt.registerLazySingleton<SearchJobsUseCase>(
      () => SearchJobsUseCase(getIt<SearchRepo>()),
    );
    getIt.registerLazySingleton<GetBookmarksUseCase>(
      () => GetBookmarksUseCase(getIt<BookmarksRepo>()),
    );
    getIt.registerLazySingleton<AddBookmarkUseCase>(
      () => AddBookmarkUseCase(getIt<BookmarksRepo>()),
    );
    getIt.registerLazySingleton<RemoveBookmarkUseCase>(
      () => RemoveBookmarkUseCase(getIt<BookmarksRepo>()),
    );
    getIt.registerLazySingleton<CheckBookmarkUseCase>(
      () => CheckBookmarkUseCase(getIt<BookmarksRepo>()),
    );
    getIt.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(getIt<UserRepo>()),
    );
    getIt.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(getIt<UserRepo>()),
    );
    getIt.registerLazySingleton<GetChatsUseCase>(
      () => GetChatsUseCase(getIt<ChatRepo>()),
    );
    getIt.registerLazySingleton<CreateOrGetChatUseCase>(
      () => CreateOrGetChatUseCase(getIt<ChatRepo>()),
    );
    getIt.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(getIt<ChatRepo>()),
    );
    getIt.registerLazySingleton<SendMessageUseCase>(
      () => SendMessageUseCase(getIt<ChatRepo>()),
    );
    getIt.registerLazySingleton<ApplyForJobUseCase>(
      () => ApplyForJobUseCase(getIt<ApplicationsRepo>()),
    );
    getIt.registerLazySingleton<GetMyApplicationsUseCase>(
      () => GetMyApplicationsUseCase(getIt<ApplicationsRepo>()),
    );
    getIt.registerLazySingleton<GetReceivedApplicationsUseCase>(
      () => GetReceivedApplicationsUseCase(getIt<ApplicationsRepo>()),
    );
    getIt.registerLazySingleton<UpdateApplicationStatusUseCase>(
      () => UpdateApplicationStatusUseCase(getIt<ApplicationsRepo>()),
    );
    getIt.registerLazySingleton<UpdateJobUseCase>(
      () => UpdateJobUseCase(getIt<JobsRepo>()),
    );
    getIt.registerLazySingleton<DeleteJobUseCase>(
      () => DeleteJobUseCase(getIt<JobsRepo>()),
    );
  }
  static void _registerCubits() {
    getIt.registerFactory<LoginCubit>(
      () => LoginCubit(
        loginUseCase: getIt<LoginUseCase>(),
        prefs: getIt<SharedPreferences>(),
      ),
    );
    getIt.registerFactory<RegisterCubit>(
      () => RegisterCubit(
        registerUseCase: getIt<RegisterUseCase>(),
        prefs: getIt<SharedPreferences>(),
      ),
    );
    getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<GetHomeJobsUseCase>()));
    getIt.registerFactory<JobsCubit>(() => JobsCubit(getIt<GetJobsUseCase>()));
    getIt.registerFactory<PostJobCubit>(
      () => PostJobCubit(
        getIt<CreateJobUseCase>(),
        getIt<UpdateJobUseCase>(),
      ),
    );
    getIt.registerFactory<ManageJobsCubit>(() => ManageJobsCubit(getIt<GetMyJobsUseCase>()));
    getIt.registerFactory<ManageJobActionCubit>(
      () => ManageJobActionCubit(
        updateJob: getIt<UpdateJobUseCase>(),
        deleteJob: getIt<DeleteJobUseCase>(),
      ),
    );
    getIt.registerFactory<SearchCubit>(
      () => SearchCubit(getIt<SearchJobsUseCase>()),
    );
    getIt.registerFactory<BookmarksCubit>(
      () => BookmarksCubit(
        getBookmarksUseCase: getIt<GetBookmarksUseCase>(),
        addBookmarkUseCase: getIt<AddBookmarkUseCase>(),
        removeBookmarkUseCase: getIt<RemoveBookmarkUseCase>(),
      ),
    );
    getIt.registerFactory<BookmarkStatusCubit>(
      () => BookmarkStatusCubit(
        checkBookmark: getIt<CheckBookmarkUseCase>(),
        addBookmark: getIt<AddBookmarkUseCase>(),
        removeBookmark: getIt<RemoveBookmarkUseCase>(),
      ),
    );
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(
        getProfile: getIt<GetProfileUseCase>(),
        updateProfile: getIt<UpdateProfileUseCase>(),
        logout: getIt<LogoutUseCase>(),
      ),
    );
    getIt.registerFactory<ChatCubit>(
      () => ChatCubit(
        getChats: getIt<GetChatsUseCase>(),
        createOrGetChat: getIt<CreateOrGetChatUseCase>(),
        chatSyncService: getIt<ChatSyncService>(),
      ),
    );
    getIt.registerFactory<MessagesCubit>(
      () => MessagesCubit(
        getMessages: getIt<GetMessagesUseCase>(),
        sendMessageUseCase: getIt<SendMessageUseCase>(),
        chatSyncService: getIt<ChatSyncService>(),
      ),
    );
    getIt.registerFactory<MyApplicationsCubit>(
      () => MyApplicationsCubit(getIt<GetMyApplicationsUseCase>()),
    );
    getIt.registerFactory<ReceivedApplicationsCubit>(
      () => ReceivedApplicationsCubit(getIt<GetReceivedApplicationsUseCase>()),
    );
    getIt.registerFactory<ApplicationActionCubit>(
      () => ApplicationActionCubit(
        applyForJob: getIt<ApplyForJobUseCase>(),
        updateStatus: getIt<UpdateApplicationStatusUseCase>(),
      ),
    );
  }
  static Future<void> loadData() async {
    _handleUserToken();
    if (AppSession.isAuthenticated) {
      await _handleUserId();
    }
    _logEvent("Session data loaded");
  }
  /// Call on logout — clears session and resets scoped lazy singletons
  static void resetSession() {
    AppSession.clearSession();
    // Repos hold no user-specific state; token cleared in AppSession
  }
  // ─── Private helpers ──────────────────────────────────────────────────────
  static void _handleUserToken() {
    final prefs = getIt<SharedPreferences>();
    final saved = prefs.getString('token') ?? '';
    if (saved.isNotEmpty && !JwtDecoder.isExpired(saved)) {
      final role = prefs.getString('role') ?? 'seeker';
      AppSession.setSession(token: saved, userId: '', role: role);
    }
  }
  static Future<void> _handleUserId() async {
    try {
      final decoded = JwtDecoder.decode(AppSession.token);
      final id = decoded['id'] as String? ?? '';
      final role = decoded['role'] as String? ?? 'seeker';
      AppSession.setSession(token: AppSession.token, userId: id, role: role);
    } catch (_) {
      AppSession.clearSession();
    }
  }
  static void _logEvent(String message) {
    Logger.logEvent(
      className: 'AppSetup',
      event: message,
      methodName: 'setupServiceLocator',
    );
  }
}
