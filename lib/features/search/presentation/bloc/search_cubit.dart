import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../jobs/domain/entities/job_filter_params.dart';
import '../../domain/usecases/search_jobs_usecase.dart';

class SearchCubit extends Cubit<BaseState<List<JobModel>>> {
  final SearchJobsUseCase _searchJobs;
  SearchCubit(this._searchJobs) : super(const InitialState());

  Timer? _debounce;
  JobFilterParams _filters = const JobFilterParams();

  JobFilterParams get filters => _filters;

  void search(String query) {
    _debounce?.cancel();
    _filters = _filters.copyWith(query: query);
    if (_filters.isEmpty) {
      emit(const InitialState());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), _doSearch);
  }

  Future<void> applyFilters(JobFilterParams filters) async {
    _filters = filters;
    if (_filters.isEmpty) {
      emit(const InitialState());
      return;
    }
    await _doSearch();
  }

  Future<void> _doSearch() async {
    emit(const LoadingState());
    final result = await _searchJobs(_filters);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }

  void retry() {
    if (!_filters.isEmpty) _doSearch();
  }

  void clear() {
    _debounce?.cancel();
    _filters = const JobFilterParams();
    emit(const InitialState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
