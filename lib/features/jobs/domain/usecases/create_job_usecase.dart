import 'package:fpdart/fpdart.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';
import '../entities/job_entity.dart';

class CreateJobUseCase implements UseCase<JobEntity, Map<String, dynamic>> {
  final JobsRepo _repo;

  CreateJobUseCase(this._repo);

  @override
  Future<Either<Failure, JobEntity>> call(Map<String, dynamic> params) async {
    try {
      final job = await _repo.createJob(params);
      return Right(job);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
