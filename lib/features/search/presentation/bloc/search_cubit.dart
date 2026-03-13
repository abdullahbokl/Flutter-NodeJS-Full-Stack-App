import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../domain/usecases/search_jobs_usecase.dart';

class SearchCubit extends Cubit<BaseState<List<JobModel>>> {
  final SearchJobsUseCase _searchJobs;
  SearchCubit(this._searchJobs) : super(const InitialState());

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
    final result = await _searchJobs(SearchJobsParams(query));
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

  static List<JobModel> _parse(dynamic raw) {
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return [];
    return list.map((e) => JobModel.fromMap(e)).toList();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
