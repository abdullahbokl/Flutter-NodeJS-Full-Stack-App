import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';
import '../entities/job_entity.dart';

class GetJobsUseCase implements UseCase<List<JobEntity>, NoParams> {
  final JobsRepo _repository;

  const GetJobsUseCase(this._repository);

  @override
  Future<Either<Failure, List<JobEntity>>> call(NoParams params) async {
    try {
      final jobs = await _repository.getAllJobs();
      return Right(
        jobs
            .map(
              (job) => JobEntity(
                id: job.id,
                title: job.title,
                description: job.description,
                location: job.location,
                salary: job.salary,
                company: job.company,
                period: job.period,
                contract: job.contract,
                requirements: job.requirements,
                imageUrl: job.imageUrl,
                agentId: job.agentId,
              ),
            )
            .toList(),
      );
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

