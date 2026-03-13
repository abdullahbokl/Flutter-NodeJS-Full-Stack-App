import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/utils/app_session.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginCubit extends Cubit<BaseState<UserEntity>> {
  final LoginUseCase _loginUseCase;
  final SharedPreferences _prefs;

  LoginCubit({
    required LoginUseCase loginUseCase,
    required SharedPreferences prefs,
  })  : _loginUseCase = loginUseCase,
        _prefs = prefs,
        super(const InitialState());

  Future<void> login(String email, String password) async {
    emit(const LoadingState());
    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (user) => _handleSuccess(user),
    );
  }

  Future<void> loginWithUsername(String userName, String password) async {
    emit(const LoadingState());
    final result = await _loginUseCase(
      LoginParams(userName: userName, password: password),
    );
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (user) => _handleSuccess(user),
    );
  }

  void _handleSuccess(UserEntity user) {
    AppSession.setSession(token: user.token, userId: user.id, role: user.role.name);
    _prefs.setString('token', user.token);
    _prefs.setString('role', user.role.name);
    emit(SuccessState(user));
  }

  void reset() => emit(const InitialState());
}

