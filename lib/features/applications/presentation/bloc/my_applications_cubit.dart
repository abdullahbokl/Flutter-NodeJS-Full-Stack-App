import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/job_application_model.dart';
import '../../domain/usecases/get_my_applications_usecase.dart';

class MyApplicationsCubit extends Cubit<BaseState<List<JobApplicationModel>>> {
  final GetMyApplicationsUseCase _getMyApplications;

  MyApplicationsCubit(this._getMyApplications) : super(const InitialState());

  Future<void> loadApplications() async {
    emit(const LoadingState());
    final result = await _getMyApplications(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (applications) => emit(
        applications.isEmpty ? const EmptyState() : SuccessState(applications),
      ),
    );
  }
}

