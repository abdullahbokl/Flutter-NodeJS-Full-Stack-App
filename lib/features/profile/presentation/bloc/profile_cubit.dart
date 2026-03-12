import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_strings.dart';

class ProfileCubit extends Cubit<BaseState<UserModel>> {
  ProfileCubit() : super(const InitialState());

  Future<void> loadProfile() async {
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().get(
        endPoint: '${AppStrings.apiUsersUrl}/${AppSession.userId}',
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      emit(SuccessState(UserModel.fromMap(data)));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    final current = state;
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().put(
        endPoint: '${AppStrings.apiUsersUrl}/${AppSession.userId}',
        data: updates,
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      emit(SuccessState(UserModel.fromMap(data)));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
      if (current is SuccessState<UserModel>) emit(current);
    }
  }

  void updateLocally(UserModel user) => emit(SuccessState(user));
}

