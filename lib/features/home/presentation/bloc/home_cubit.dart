import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../domain/usecases/get_home_jobs_usecase.dart';

class HomeCubit extends Cubit<BaseState<List<JobModel>>> {
  final GetHomeJobsUseCase _getHomeJobs;

  HomeCubit(this._getHomeJobs) : super(const InitialState());

  Future<void> loadJobs() async {
    emit(const LoadingState());
    final result = await _getHomeJobs(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }
}
