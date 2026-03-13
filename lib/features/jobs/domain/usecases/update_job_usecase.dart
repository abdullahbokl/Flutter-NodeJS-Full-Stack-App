import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';
import '../entities/job_entity.dart';

class UpdateJobParams {
  final String jobId;
  final Map<String, dynamic> data;

  const UpdateJobParams({
    required this.jobId,
    required this.data,
  });
}

class UpdateJobUseCase {
  final JobsRepo _repo;

  const UpdateJobUseCase(this._repo);

  Future<Either<Failure, JobEntity>> call(UpdateJobParams params) async {
    try {
      final job = await _repo.updateJob(params.jobId, params.data);
      return Right(job);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

