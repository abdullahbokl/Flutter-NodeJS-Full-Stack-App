import 'package:fpdart/fpdart.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';
import '../entities/job_entity.dart';

class GetMyJobsUseCase implements UseCase<List<JobEntity>, NoParams> {
  final JobsRepo _repo;

  GetMyJobsUseCase(this._repo);

  @override
  Future<Either<Failure, List<JobEntity>>> call(NoParams params) async {
    try {
      final jobs = await _repo.getMyJobs(includeArchived: true);
      return Right(jobs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
