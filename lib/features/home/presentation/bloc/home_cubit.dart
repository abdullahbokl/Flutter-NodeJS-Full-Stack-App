import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';

class HomeCubit extends Cubit<BaseState<List<JobModel>>> {
  HomeCubit() : super(const InitialState());

  Future<void> loadJobs() async {
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().get(endPoint: AppStrings.apiJobs);
      final list = _parse(raw);
      emit(list.isEmpty ? const EmptyState() : SuccessState(list));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  static List<JobModel> _parse(dynamic raw) {
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return [];
    return list.map((e) => JobModel.fromMap(e)).toList();
  }
}

