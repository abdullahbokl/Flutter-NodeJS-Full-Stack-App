import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../domain/usecases/search_jobs_usecase.dart';

class SearchCubit extends Cubit<BaseState<List<JobModel>>> {
  final SearchJobsUseCase _searchJobsUseCase;

  SearchCubit(this._searchJobsUseCase) : super(const InitialState());

  Timer? _debounce;
  String _lastQuery = '';

  void search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      emit(const InitialState());
      return;
    }
    _lastQuery = query.trim();
    _debounce = Timer(const Duration(milliseconds: 350), () => _doSearch(query.trim()));
  }

  Future<void> _doSearch(String query) async {
    emit(const LoadingState());
    final result = await _searchJobsUseCase(SearchJobsParams(query));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }

  void retry() {
    if (_lastQuery.isNotEmpty) _doSearch(_lastQuery);
  }

  void clear() {
    _debounce?.cancel();
    _lastQuery = '';
    emit(const InitialState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

