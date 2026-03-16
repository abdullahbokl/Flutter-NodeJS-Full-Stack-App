import 'package:shared_preferences/shared_preferences.dart';

import '../../../service_locator.dart';
import '../../../../../features/auth/domain/usecases/login_usecase.dart';
import '../../../../../features/auth/domain/usecases/logout_usecase.dart';
import '../../../../../features/auth/domain/usecases/register_usecase.dart';
import '../../../../../features/auth/presentation/bloc/login_cubit.dart';
import '../../../../../features/auth/presentation/bloc/register_cubit.dart';
import '../../../../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../../../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../../../../features/profile/presentation/bloc/profile_cubit.dart';

void registerAuthCubits() {
  serviceLocator.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: serviceLocator<LoginUseCase>(),
      prefs: serviceLocator<SharedPreferences>(),
    ),
  );
  serviceLocator.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      registerUseCase: serviceLocator<RegisterUseCase>(),
      prefs: serviceLocator<SharedPreferences>(),
    ),
  );
  serviceLocator.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfile: serviceLocator<GetProfileUseCase>(),
      updateProfile: serviceLocator<UpdateProfileUseCase>(),
      logout: serviceLocator<LogoutUseCase>(),
    ),
  );
}
