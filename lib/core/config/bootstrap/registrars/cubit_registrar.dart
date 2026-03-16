import '../../../../features/auth/presentation/bloc/login_cubit.dart';
import '../../service_locator.dart';
import 'support/auth_cubits_registrar.dart';
import 'support/feature_cubits_registrar.dart';

class CubitRegistrar {
  const CubitRegistrar();

  void register() {
    if (serviceLocator.isRegistered<LoginCubit>()) {
      return;
    }

    registerAuthCubits();
    registerFeatureCubits();
  }
}
