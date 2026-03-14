import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../jobs/data/repositories/jobs_repo.dart';

class GetHomeJobsUseCase implements UseCase<List<JobModel>, NoParams> {
  final JobsRepo _repository;

  const GetHomeJobsUseCase(this._repository);

  @override
  Future<Either<Failure, List<JobModel>>> call(NoParams params) async {
    try {
      final jobs = await _repository.getAllJobs();
      return Right(jobs.jobs.cast<JobModel>());
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}
