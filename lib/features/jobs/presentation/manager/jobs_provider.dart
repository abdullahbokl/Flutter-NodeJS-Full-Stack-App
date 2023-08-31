import 'package:flutter/material.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';

class JobsProvider extends ChangeNotifier {
  // variables
  final ApiServices _apiServices = getIt<ApiServices>();
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
    final allJobs = await _apiServices.get(
      endPoint: AppStrings.apiJobs,
    );
    if (allJobs != null) {
      _jobs.clear();
      allJobs.forEach((job) {
        _jobs.add(JobModel.fromMap(job));
      });
    }
    _isLoading = false;
    notifyListeners();
  }
}
