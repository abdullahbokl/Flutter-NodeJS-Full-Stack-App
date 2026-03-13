import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/job_application_model.dart';
import '../../data/repositories/applications_repo.dart';

class GetReceivedApplicationsUseCase {
  final ApplicationsRepo _repo;

  const GetReceivedApplicationsUseCase(this._repo);

  Future<Either<Failure, List<JobApplicationModel>>> call(NoParams params) async {
    try {
      final applications = await _repo.getReceivedApplications();
      return Right(applications);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

