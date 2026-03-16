import '../../../../features/auth/domain/usecases/login_usecase.dart';
import '../../service_locator.dart';
import 'support/auth_use_cases_registrar.dart';
import 'support/feature_use_cases_registrar.dart';
import 'support/job_use_cases_registrar.dart';

class UseCaseRegistrar {
  const UseCaseRegistrar();

  void register() {
    if (serviceLocator.isRegistered<LoginUseCase>()) {
      return;
    }

    registerAuthUseCases();
    registerJobUseCases();
    registerFeatureUseCases();
  }
}
