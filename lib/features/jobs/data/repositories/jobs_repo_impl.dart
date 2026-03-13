import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../domain/entities/job_filter_params.dart';
import 'jobs_repo.dart';

class JobsRepoImpl implements JobsRepo {
  final ApiServices _apiServices;

  JobsRepoImpl(this._apiServices);

  @override
  Future<List<JobModel>> getAllJobs({
    JobFilterParams filters = const JobFilterParams(),
  }) async {
    try {
      final raw = await _apiServices.get(
        endPoint: ApiEndpoints.jobs,
        queryParameters: filters.toQueryParameters(),
      );
      final jobsData = raw is Map ? raw['data'] : raw;
      if (jobsData is! List) return [];
      return jobsData
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<List<JobModel>> getMyJobs({bool includeArchived = false}) async {
    try {
      final raw = await _apiServices.get(
        endPoint: '${ApiEndpoints.jobs}/my-jobs',
        queryParameters: includeArchived ? {'includeArchived': 'true'} : null,
      );
      final jobsData = raw is Map ? raw['data'] : raw;
      if (jobsData is! List) return [];
      return jobsData
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<JobModel> createJob(Map<String, dynamic> jobData) async {
    try {
      final raw = await _apiServices.post(
        endPoint: ApiEndpoints.jobs,
        data: jobData,
      );
      final data = raw is Map ? raw['data'] : raw;
      return JobModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<JobModel> updateJob(String jobId, Map<String, dynamic> jobData) async {
    try {
      final raw = await _apiServices.put(
        endPoint: '${ApiEndpoints.jobs}/$jobId',
        data: jobData,
      );
      final data = raw is Map ? raw['data'] : raw;
      return JobModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    try {
      await _apiServices.delete(endPoint: '${ApiEndpoints.jobs}/$jobId');
    } catch (e) {
      throw handleServerError(e);
    }
  }
}
