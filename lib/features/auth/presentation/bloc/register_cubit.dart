import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterCubit extends Cubit<BaseState<UserEntity>> {
  final AuthRepository _repo;

  RegisterCubit(this._repo) : super(const InitialState());

  Future<void> register(String userName, String email, String password) async {
    emit(const LoadingState());
    final result = await _repo.register(userName, email, password);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (user) {
        AppSession.setSession(token: user.token, userId: user.id);
        getIt<SharedPreferences>().setString(AppStrings.userToken, user.token);
        emit(SuccessState(user));
      },
    );
  }

  void reset() => emit(const InitialState());
}

