import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/bloc/theme_cubit.dart';
import '../../service_locator.dart';

class BootstrapInfrastructureRegistrar {
  const BootstrapInfrastructureRegistrar();

  Future<void> register() async {
    if (serviceLocator.isRegistered<SharedPreferences>() &&
        serviceLocator.isRegistered<ThemeCubit>()) {
      return;
    }

    final preferences = await SharedPreferences.getInstance();
    if (!serviceLocator.isRegistered<SharedPreferences>()) {
      serviceLocator
          .registerLazySingleton<SharedPreferences>(() => preferences);
    }
    if (!serviceLocator.isRegistered<ThemeCubit>()) {
      serviceLocator.registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(serviceLocator<SharedPreferences>()),
      );
    }
  }
}
