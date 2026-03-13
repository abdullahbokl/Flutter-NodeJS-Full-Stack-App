import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileCubit extends Cubit<BaseState<UserModel>> {
  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final LogoutUseCase _logout;

  ProfileCubit({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
    required LogoutUseCase logout,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _logout = logout,
        super(const InitialState());

  Future<void> loadProfile() async {
    emit(const LoadingState());
    final result = await _getProfile(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (user) => emit(SuccessState(user)),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final current = state;
    emit(const LoadingState());
    final result = await _updateProfile(UpdateProfileParams(updates));
    result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        if (current is SuccessState<UserModel>) emit(current);
      },
      (user) => emit(SuccessState(user)),
    );
  }

  Future<void> logout() async {
    await _logout(const NoParams());
  }

  void updateLocally(UserModel user) => emit(SuccessState(user));
}

