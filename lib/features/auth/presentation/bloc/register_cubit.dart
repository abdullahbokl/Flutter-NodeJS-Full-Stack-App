import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/utils/app_session.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterCubit extends Cubit<BaseState<UserEntity>> {
  final RegisterUseCase _registerUseCase;
  final SharedPreferences _prefs;

  RegisterCubit({
    required RegisterUseCase registerUseCase,
    required SharedPreferences prefs,
  })  : _registerUseCase = registerUseCase,
        _prefs = prefs,
        super(const InitialState());

  Future<void> register(
    String userName,
    String email,
    String password, {
    UserRole role = UserRole.seeker,
    String? companyName,
  }) async {
    emit(const LoadingState());
    final result = await _registerUseCase(
      RegisterParams(
        userName: userName,
        email: email,
        password: password,
        role: role,
        companyName: companyName,
      ),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (user) {
        AppSession.setSession(token: user.token, userId: user.id, role: user.role.name);
        _prefs.setString('token', user.token);
        _prefs.setString('role', user.role.name);
        emit(SuccessState(user));
      },
    );
  }

  void reset() => emit(const InitialState());
}

