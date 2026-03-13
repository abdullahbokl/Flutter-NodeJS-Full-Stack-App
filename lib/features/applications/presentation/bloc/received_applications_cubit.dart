import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/job_application_model.dart';
import '../../domain/usecases/get_received_applications_usecase.dart';

class ReceivedApplicationsCubit extends Cubit<BaseState<List<JobApplicationModel>>> {
  final GetReceivedApplicationsUseCase _getReceivedApplications;

  ReceivedApplicationsCubit(this._getReceivedApplications)
      : super(const InitialState());

  Future<void> loadApplications() async {
    emit(const LoadingState());
    final result = await _getReceivedApplications(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (applications) => emit(
        applications.isEmpty ? const EmptyState() : SuccessState(applications),
      ),
    );
  }
}

