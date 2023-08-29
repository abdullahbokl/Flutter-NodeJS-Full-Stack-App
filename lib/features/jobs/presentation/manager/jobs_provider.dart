import 'package:flutter/material.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../data/repositories/jobs_repo_impl.dart';

class JobsProvider extends ChangeNotifier {
  JobsProvider() {
    _logger("JobsProvider initialized");
  }

  // variables
  final JobsRepoImpl _jobsRepoImpl = getIt<JobsRepoImpl>();
  bool _isLoading = false;
  final List<JobModel> _jobs = [];

  // getters
  bool get isLoading => _isLoading;

  List<JobModel> get jobs => _jobs;

  // setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // methods
  getAllJobs() async {
    _isLoading = true;
    _jobs.clear();
    try {
      final List<JobModel> allJobs = await _jobsRepoImpl.getAllJobs();
      if (allJobs.isNotEmpty) {
        _jobs.addAll(allJobs);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      Logger.logEvent(
        className: "JobsProvider",
        event: e.toString(),
        methodName: "getAllJobs",
      );
      rethrow;
    }
  }

  @override
  void dispose() {
    _logger("JobsProvider disposed");
    super.dispose();
  }

  void _logger(String e) {
    Logger.logEvent(
      className: "JobsProvider",
      event: e,
    );
  }
}
