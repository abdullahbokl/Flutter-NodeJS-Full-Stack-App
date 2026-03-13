import 'package:jobhub_flutter/core/services/logger.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import 'search_repo.dart';

class SearchRepoImpl implements SearchRepo {
  final ApiServices _apiServices;

  SearchRepoImpl(this._apiServices);

  @override
  Future<List<JobModel>> searchJobs(String query) async {
    try {
      final raw = await _apiServices.get(
        endPoint: "${ApiEndpoints.search}/$query",
      );
      final jobsData = raw is Map ? raw['data'] : raw;
      if (jobsData is! List) return [];
      return jobsData
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();
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
