import '../../../../features/applications/data/repositories/applications_repo.dart';
import '../../../../features/applications/data/repositories/applications_repo_impl.dart';
import '../../../../features/auth/data/repositories/auth_repo/auth_repo_impl.dart';
import '../../../../features/auth/data/repositories/auth_repository/auth_repository_impl.dart';
import '../../../../features/auth/data/repositories/user_repo/user_repo.dart';
import '../../../../features/auth/data/repositories/user_repo/user_repo_impl.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../../features/bookmarks/data/repositories/bookmarks_repo.dart';
import '../../../../features/bookmarks/data/repositories/bookmarks_repo_impl.dart';
import '../../../../features/chat/data/repositories/chat_repo.dart';
import '../../../../features/chat/data/repositories/chat_repo_impl.dart';
import '../../../../features/jobs/data/repositories/jobs_repo.dart';
import '../../../../features/jobs/data/repositories/jobs_repo_impl.dart';
import '../../../../features/search/data/repositories/search_repo.dart';
import '../../../../features/search/data/repositories/search_repo_impl.dart';
import '../../../services/api_services.dart';
import '../../service_locator.dart';

class RepositoryRegistrar {
  const RepositoryRegistrar();

  void register() {
    _registerDataSources();
    _registerContracts();
  }

  void _registerDataSources() {
    if (!serviceLocator.isRegistered<AuthRepoImpl>()) {
      serviceLocator.registerLazySingleton<AuthRepoImpl>(
        () => AuthRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<UserRepoImpl>()) {
      serviceLocator.registerLazySingleton<UserRepoImpl>(
        () => UserRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<SearchRepoImpl>()) {
      serviceLocator.registerLazySingleton<SearchRepoImpl>(
        () => SearchRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<JobsRepoImpl>()) {
      serviceLocator.registerLazySingleton<JobsRepoImpl>(
        () => JobsRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<BookmarksRepoImpl>()) {
      serviceLocator.registerLazySingleton<BookmarksRepoImpl>(
        () => BookmarksRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<ChatRepoImpl>()) {
      serviceLocator.registerLazySingleton<ChatRepoImpl>(
        () => ChatRepoImpl(serviceLocator<ApiServices>()),
      );
    }
    if (!serviceLocator.isRegistered<ApplicationsRepoImpl>()) {
      serviceLocator.registerLazySingleton<ApplicationsRepoImpl>(
        () => ApplicationsRepoImpl(serviceLocator<ApiServices>()),
      );
    }
  }

  void _registerContracts() {
    if (!serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator<AuthRepoImpl>()),
      );
    }
    if (!serviceLocator.isRegistered<UserRepo>()) {
      serviceLocator.registerLazySingleton<UserRepo>(
        () => serviceLocator<UserRepoImpl>(),
      );
    }
    if (!serviceLocator.isRegistered<SearchRepo>()) {
      serviceLocator.registerLazySingleton<SearchRepo>(
        () => serviceLocator<SearchRepoImpl>(),
      );
    }
    if (!serviceLocator.isRegistered<JobsRepo>()) {
      serviceLocator.registerLazySingleton<JobsRepo>(
        () => serviceLocator<JobsRepoImpl>(),
      );
    }
    if (!serviceLocator.isRegistered<BookmarksRepo>()) {
      serviceLocator.registerLazySingleton<BookmarksRepo>(
        () => serviceLocator<BookmarksRepoImpl>(),
      );
    }
    if (!serviceLocator.isRegistered<ChatRepo>()) {
      serviceLocator.registerLazySingleton<ChatRepo>(
        () => serviceLocator<ChatRepoImpl>(),
      );
    }
    if (!serviceLocator.isRegistered<ApplicationsRepo>()) {
      serviceLocator.registerLazySingleton<ApplicationsRepo>(
        () => serviceLocator<ApplicationsRepoImpl>(),
      );
    }
  }
}
