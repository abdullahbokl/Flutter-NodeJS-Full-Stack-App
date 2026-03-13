import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../jobs/domain/entities/job_filter_params.dart';
import '../../data/repositories/search_repo.dart';

class SearchJobsUseCase implements UseCase<List<JobModel>, JobFilterParams> {
  final SearchRepo _repository;

  const SearchJobsUseCase(this._repository);

  @override
  Future<Either<Failure, List<JobModel>>> call(JobFilterParams params) async {
    try {
      final jobs = await _repository.searchJobs(params);
      return Right(jobs);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}
