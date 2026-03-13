import '../../../../core/common/models/job_model.dart';
import '../../../jobs/domain/entities/job_filter_params.dart';

abstract class SearchRepo {
  Future<List<JobModel>> searchJobs(JobFilterParams filters);
}
