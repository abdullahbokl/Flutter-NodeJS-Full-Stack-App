import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/entities/job_entity.dart';

class JobsCubit extends Cubit<BaseState<List<JobEntity>>> {
  final GetJobsUseCase _getJobsUseCase;

  JobsCubit(this._getJobsUseCase) : super(const InitialState());

  Future<void> loadJobs() async {
    emit(const LoadingState());
    final result = await _getJobsUseCase(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }
}


