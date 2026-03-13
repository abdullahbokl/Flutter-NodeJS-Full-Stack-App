import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/search_repo.dart';

class SearchJobsParams {
  final String query;

  const SearchJobsParams(this.query);
}

class SearchJobsUseCase implements UseCase<List<JobModel>, SearchJobsParams> {
  final SearchRepo _repository;

  const SearchJobsUseCase(this._repository);

  @override
  Future<Either<Failure, List<JobModel>>> call(SearchJobsParams params) async {
    try {
      final jobs = await _repository.searchJobs(params.query);
      return Right(jobs);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

