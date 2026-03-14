import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';
import '../entities/job_filter_params.dart';
import '../entities/paginated_jobs_result.dart';

class GetJobsUseCase implements UseCase<PaginatedJobsResult, JobFilterParams> {
  final JobsRepo _repository;

  const GetJobsUseCase(this._repository);

  @override
  Future<Either<Failure, PaginatedJobsResult>> call(JobFilterParams params) async {
    try {
      final jobs = await _repository.getAllJobs(filters: params);
      return Right(jobs);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}
