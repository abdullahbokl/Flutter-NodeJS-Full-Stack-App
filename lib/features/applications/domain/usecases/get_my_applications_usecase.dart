import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/job_application_model.dart';
import '../../data/repositories/applications_repo.dart';

class GetMyApplicationsUseCase {
  final ApplicationsRepo _repo;

  const GetMyApplicationsUseCase(this._repo);

  Future<Either<Failure, List<JobApplicationModel>>> call(NoParams params) async {
    try {
      final applications = await _repo.getMyApplications();
      return Right(applications);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

