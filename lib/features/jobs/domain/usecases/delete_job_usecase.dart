import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../data/repositories/jobs_repo.dart';

class DeleteJobUseCase {
  final JobsRepo _repo;

  const DeleteJobUseCase(this._repo);

  Future<Either<Failure, void>> call(String jobId) async {
    try {
      await _repo.deleteJob(jobId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

