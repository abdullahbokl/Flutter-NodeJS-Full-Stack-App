import '../../../../core/common/models/job_model.dart';

abstract class JobsRepo {
  Future<List<JobModel>> getAllJobs();
  Future<List<JobModel>> getMyJobs();
  Future<JobModel> createJob(Map<String, dynamic> jobData);
}
