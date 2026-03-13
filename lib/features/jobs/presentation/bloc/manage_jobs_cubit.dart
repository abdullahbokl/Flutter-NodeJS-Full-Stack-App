import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../domain/usecases/get_my_jobs_usecase.dart';
import '../../domain/entities/job_entity.dart';

class ManageJobsCubit extends Cubit<BaseState<List<JobEntity>>> {
  final GetMyJobsUseCase _getMyJobsUseCase;

  ManageJobsCubit(this._getMyJobsUseCase) : super(const InitialState());

  Future<void> loadMyJobs() async {
    emit(const LoadingState());
    final result = await _getMyJobsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }
}
