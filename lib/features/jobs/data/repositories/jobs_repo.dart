import '../../../../core/common/models/job_model.dart';
import '../../domain/entities/job_filter_params.dart';
import '../../domain/entities/paginated_jobs_result.dart';

abstract class JobsRepo {
  Future<PaginatedJobsResult> getAllJobs({JobFilterParams filters = const JobFilterParams()});
  Future<List<JobModel>> getMyJobs({bool includeArchived = false});
  Future<JobModel> createJob(Map<String, dynamic> jobData);
  Future<JobModel> updateJob(String jobId, Map<String, dynamic> jobData);
  Future<void> deleteJob(String jobId);
}
