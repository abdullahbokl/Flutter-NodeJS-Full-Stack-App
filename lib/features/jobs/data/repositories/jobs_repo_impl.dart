import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import 'jobs_repo.dart';

class JobsRepoImpl implements JobsRepo {
  final ApiServices _apiServices;

  JobsRepoImpl(this._apiServices);

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      final raw = await _apiServices.get(
        endPoint: ApiEndpoints.jobs,
      );
      final jobsData = raw is Map ? raw['data'] : raw;
      if (jobsData is! List) return [];
      return jobsData
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();
    } catch (e) {
      handleServerError(e);
      throw handleServerError(e);
    }
  }
}
