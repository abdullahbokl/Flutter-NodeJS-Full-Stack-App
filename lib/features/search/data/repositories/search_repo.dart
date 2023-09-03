import '../../../../core/common/models/job_model.dart';

abstract class SearchRepo {
  Future<List<JobModel>> searchJobs(String query);
}
