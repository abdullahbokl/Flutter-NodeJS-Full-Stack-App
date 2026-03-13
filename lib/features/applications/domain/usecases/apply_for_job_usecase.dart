import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/job_application_model.dart';
import '../../data/repositories/applications_repo.dart';

class ApplyForJobParams {
  final String jobId;
  final String coverLetter;

  const ApplyForJobParams({
    required this.jobId,
    required this.coverLetter,
  });
}

class ApplyForJobUseCase {
  final ApplicationsRepo _repo;

  const ApplyForJobUseCase(this._repo);

  Future<Either<Failure, JobApplicationModel>> call(ApplyForJobParams params) async {
    try {
      final result = await _repo.applyForJob(
        jobId: params.jobId,
        coverLetter: params.coverLetter,
      );
      return Right(result);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

