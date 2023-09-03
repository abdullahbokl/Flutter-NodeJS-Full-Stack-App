import 'package:jobhub_flutter/core/services/logger.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';
import 'search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  final ApiServices _apiServices;

  SearchRepoImpl(this._apiServices);

  @override
  Future<List<JobModel>> searchJobs(String query) async {
    List<JobModel> jobs = [];
    try {
      final List<dynamic> jobsData = await _apiServices.get(
        endPoint: "${AppStrings.apiSearch}/$query",
      );

      for (final job in jobsData) {
        jobs.add(JobModel.fromMap(job));
      }
      return jobs;
    } catch (e) {
      _searchJobsLogger(handleServerError(e));
      throw handleServerError(e);
    }
  }

  void _searchJobsLogger(String e) {
    Logger.logEvent(
      className: "SearchRepoImpl",
      event: e,
      methodName: "searchJobs",
    );
  }
}
