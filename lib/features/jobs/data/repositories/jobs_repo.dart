import '../../../../core/common/models/job_model.dart';

abstract class JobsRepo {
  Future<List<JobModel>> getAllJobs();
}
