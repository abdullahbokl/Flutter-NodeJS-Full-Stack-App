import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../domain/usecases/create_job_usecase.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/usecases/update_job_usecase.dart';

class PostJobCubit extends Cubit<BaseState<JobEntity>> {
  final CreateJobUseCase _createJobUseCase;
  final UpdateJobUseCase _updateJobUseCase;

  PostJobCubit(this._createJobUseCase, this._updateJobUseCase)
      : super(const InitialState());

  Future<void> submitJob(Map<String, dynamic> jobData, {String? jobId}) async {
    emit(const LoadingState());
    final result = jobId == null
        ? await _createJobUseCase(jobData)
        : await _updateJobUseCase(UpdateJobParams(jobId: jobId, data: jobData));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (job) => emit(SuccessState(job)),
    );
  }
}
