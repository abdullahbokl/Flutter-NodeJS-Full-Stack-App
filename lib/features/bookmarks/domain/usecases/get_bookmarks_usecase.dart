import 'package:fpdart/fpdart.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/bookmarks_repo.dart';

class GetBookmarksUseCase implements UseCase<List<JobModel>, NoParams> {
  final BookmarksRepo _repository;

  const GetBookmarksUseCase(this._repository);

  @override
  Future<Either<Failure, List<JobModel>>> call(NoParams params) async {
    try {
      final jobs = await _repository.getBookmarkedJobs();
      return Right(jobs);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

