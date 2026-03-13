import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/job_application_model.dart';
import '../../data/repositories/applications_repo.dart';

class UpdateApplicationStatusParams {
  final String applicationId;
  final String status;

  const UpdateApplicationStatusParams({
    required this.applicationId,
    required this.status,
  });
}

class UpdateApplicationStatusUseCase {
  final ApplicationsRepo _repo;

  const UpdateApplicationStatusUseCase(this._repo);

  Future<Either<Failure, JobApplicationModel>> call(
    UpdateApplicationStatusParams params,
  ) async {
    try {
      final updated = await _repo.updateApplicationStatus(
        applicationId: params.applicationId,
        status: params.status,
      );
      return Right(updated);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

