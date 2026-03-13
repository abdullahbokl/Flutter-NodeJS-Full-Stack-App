import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/usecases/delete_job_usecase.dart';
import '../../domain/usecases/update_job_usecase.dart';

class ManageJobActionCubit extends Cubit<BaseState<JobEntity?>> {
  final UpdateJobUseCase _updateJob;
  final DeleteJobUseCase _deleteJob;

  ManageJobActionCubit({
    required UpdateJobUseCase updateJob,
    required DeleteJobUseCase deleteJob,
  })  : _updateJob = updateJob,
        _deleteJob = deleteJob,
        super(const InitialState());

  Future<bool> archiveJob(String jobId, bool isArchived) async {
    emit(const LoadingState());
    final result = await _updateJob(
      UpdateJobParams(jobId: jobId, data: {'isArchived': isArchived}),
    );
    return result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        return false;
      },
      (job) {
        emit(SuccessState(job));
        return true;
      },
    );
  }

  Future<bool> deleteJob(String jobId) async {
    emit(const LoadingState());
    final result = await _deleteJob(jobId);
    return result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        return false;
      },
      (_) {
        emit(const SuccessState(null));
        return true;
      },
    );
  }
}
