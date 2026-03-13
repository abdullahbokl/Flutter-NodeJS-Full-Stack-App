import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../domain/usecases/create_job_usecase.dart';
import '../../domain/entities/job_entity.dart';

class PostJobCubit extends Cubit<BaseState<JobEntity>> {
  final CreateJobUseCase _createJobUseCase;

  PostJobCubit(this._createJobUseCase) : super(const InitialState());

  Future<void> submitJob(Map<String, dynamic> jobData) async {
    emit(const LoadingState());
    final result = await _createJobUseCase(jobData);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (job) => emit(SuccessState(job)),
    );
  }
}
