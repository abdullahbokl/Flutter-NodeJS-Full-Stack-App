import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../data/models/job_application_model.dart';
import '../../domain/usecases/apply_for_job_usecase.dart';
import '../../domain/usecases/update_application_status_usecase.dart';

class ApplicationActionCubit extends Cubit<BaseState<JobApplicationModel>> {
  final ApplyForJobUseCase _applyForJob;
  final UpdateApplicationStatusUseCase _updateStatus;

  ApplicationActionCubit({
    required ApplyForJobUseCase applyForJob,
    required UpdateApplicationStatusUseCase updateStatus,
  })  : _applyForJob = applyForJob,
        _updateStatus = updateStatus,
        super(const InitialState());

  Future<JobApplicationModel?> applyForJob({
    required String jobId,
    required String coverLetter,
  }) async {
    emit(const LoadingState());
    final result = await _applyForJob(
      ApplyForJobParams(jobId: jobId, coverLetter: coverLetter),
    );
    return result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        return null;
      },
      (application) {
        emit(SuccessState(application));
        return application;
      },
    );
  }

  Future<JobApplicationModel?> updateStatus({
    required String applicationId,
    required String status,
  }) async {
    emit(const LoadingState());
    final result = await _updateStatus(
      UpdateApplicationStatusParams(applicationId: applicationId, status: status),
    );
    return result.fold(
      (failure) {
        emit(ErrorState(failure.message));
        return null;
      },
      (application) {
        emit(SuccessState(application));
        return application;
      },
    );
  }
}

