import '../../../service_locator.dart';
import '../../../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../../../features/auth/domain/usecases/login_usecase.dart';
import '../../../../../features/auth/domain/usecases/logout_usecase.dart';
import '../../../../../features/auth/domain/usecases/register_usecase.dart';

void registerAuthUseCases() {
  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(serviceLocator<AuthRepository>()),
  );
  serviceLocator.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(serviceLocator<AuthRepository>()),
  );
}
