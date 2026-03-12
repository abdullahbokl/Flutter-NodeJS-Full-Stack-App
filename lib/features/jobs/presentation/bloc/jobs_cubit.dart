import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/job_entity.dart';

class JobsCubit extends Cubit<BaseState<List<JobEntity>>> {
  JobsCubit() : super(const InitialState());

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

  static List<JobEntity> _parse(dynamic raw) {
    if (raw is Map && raw['data'] != null) {
      return (raw['data'] as List).map(JobEntity.fromMap).toList();
    }
    if (raw is List) return raw.map(JobEntity.fromMap).toList();
    return [];
  }
}


