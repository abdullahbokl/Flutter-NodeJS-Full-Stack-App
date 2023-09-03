import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';
import 'jobs_repo.dart';

class JobsRepoImpl implements JobsRepo {
  final ApiServices _apiServices;

  JobsRepoImpl(this._apiServices);

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      final List<JobModel> allJobs = [];
      final List? jobsData = await _apiServices.get(
        endPoint: AppStrings.apiJobs,
      );
      if (jobsData != null) {
        for (var job in jobsData) {
          allJobs.add(JobModel.fromMap(job));
        }
      }
      return allJobs;
    } catch (e) {
      handleServerError(e);
      throw handleServerError(e);
    }
  }
}
