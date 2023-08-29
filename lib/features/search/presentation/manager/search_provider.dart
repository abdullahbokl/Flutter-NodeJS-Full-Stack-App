import 'package:flutter/material.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../data/repositories/search_repo_impl.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepoImpl _searchRepoImpl = getIt<SearchRepoImpl>();
  final TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  final List<JobModel> _jobs = [];

  // getters
  bool get isLoading => _isLoading;

  List<JobModel> get jobs => _jobs;

  // setters
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  searchJobs() async {
    if (searchController.text.isEmpty) {
      _jobs.clear();
      notifyListeners();
      return;
    }
    setIsLoading(true);
    try {
      final List<JobModel> jobs =
          await _searchRepoImpl.searchJobs(searchController.text);
      _jobs.clear();
      _jobs.addAll(jobs);
      setIsLoading(false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
