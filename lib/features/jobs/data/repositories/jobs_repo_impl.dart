import '../../../../core/common/models/job_model.dart';
import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../domain/entities/job_filter_params.dart';
import '../../domain/entities/paginated_jobs_result.dart';
import 'jobs_repo.dart';

class JobsRepoImpl implements JobsRepo {
  final ApiServices _apiServices;

  JobsRepoImpl(this._apiServices);

  @override
  Future<PaginatedJobsResult> getAllJobs({
    JobFilterParams filters = const JobFilterParams(),
  }) async {
    try {
      final raw = await _apiServices.get(
        endPoint: ApiEndpoints.jobs,
        queryParameters: filters.toQueryParameters(),
      );
      final jobsData = raw is Map ? raw['data'] : null;
      final pagination = raw is Map ? raw['pagination'] : null;
      if (jobsData is! List) {
        return PaginatedJobsResult(
          jobs: const [],
          page: filters.page,
          limit: filters.limit,
          total: 0,
          totalPages: 0,
        );
      }

      final jobs = jobsData
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();

      return PaginatedJobsResult(
        jobs: jobs,
        page: pagination is Map ? (pagination['page'] as num?)?.toInt() ?? filters.page : filters.page,
        limit: pagination is Map ? (pagination['limit'] as num?)?.toInt() ?? filters.limit : filters.limit,
        total: pagination is Map ? (pagination['total'] as num?)?.toInt() ?? jobs.length : jobs.length,
        totalPages: pagination is Map
            ? (pagination['totalPages'] as num?)?.toInt() ?? (jobs.isEmpty ? 0 : 1)
            : (jobs.isEmpty ? 0 : 1),
      );
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
