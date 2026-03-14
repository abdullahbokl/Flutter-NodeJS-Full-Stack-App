import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../domain/usecases/get_jobs_usecase.dart';
import '../../domain/entities/job_filter_params.dart';
import '../../domain/entities/job_entity.dart';

class JobsCubit extends Cubit<BaseState<List<JobEntity>>> {
  final GetJobsUseCase _getJobsUseCase;
  Timer? _debounce;
  JobFilterParams _filters = const JobFilterParams();
  List<JobEntity> _jobs = const [];
  bool _isLoadingMore = false;
  bool _hasMore = true;

  JobsCubit(this._getJobsUseCase) : super(const InitialState());

  JobFilterParams get filters => _filters;
  List<JobEntity> get jobs => _jobs;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  Future<void> loadJobs([JobFilterParams? filters]) async {
    if (filters != null) {
      _filters = filters;
    }

    emit(const LoadingState());
    final result = await _getJobsUseCase(_filters);
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (paged) {
        _jobs = paged.jobs;
        _hasMore = paged.hasMore;
        _isLoadingMore = false;
        emit(_jobs.isEmpty ? const EmptyState() : SuccessState(_jobs));
      },
    );
  }

  void search(String query) {
    _debounce?.cancel();
    _filters = _filters.copyWith(query: query, page: 1);
    _debounce = Timer(const Duration(milliseconds: 350), () => loadJobs(_filters));
  }

  Future<void> applyFilters(JobFilterParams filters) async {
    await loadJobs(filters.copyWith(page: 1));
  }

  Future<void> clearFilters() async {
    _debounce?.cancel();
    await loadJobs(const JobFilterParams());
  }

  Future<void> retry() async {
    await loadJobs(_filters);
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || state is LoadingState<List<JobEntity>>) {
      return;
    }

    _isLoadingMore = true;
    final nextFilters = _filters.copyWith(page: _filters.page + 1);
    final result = await _getJobsUseCase(nextFilters);
    result.fold(
      (_) => _isLoadingMore = false,
      (paged) {
        _filters = nextFilters;
        _jobs = [..._jobs, ...paged.jobs];
        _hasMore = paged.hasMore;
        _isLoadingMore = false;
        emit(SuccessState(_jobs));
      },
    );
  }

  void reset() {
    _debounce?.cancel();
    _filters = const JobFilterParams();
    _jobs = const [];
    _isLoadingMore = false;
    _hasMore = true;
    emit(const InitialState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
