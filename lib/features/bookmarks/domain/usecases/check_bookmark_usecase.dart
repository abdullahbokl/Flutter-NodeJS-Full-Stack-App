import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/bookmarks_repo.dart';

class CheckBookmarkParams {
  final String jobId;
  const CheckBookmarkParams(this.jobId);
}

class CheckBookmarkUseCase implements UseCase<bool, CheckBookmarkParams> {
  final BookmarksRepo _repository;

  const CheckBookmarkUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CheckBookmarkParams params) async {
    try {
      final isBookmarked = await _repository.isBookmarked(params.jobId);
      return Right(isBookmarked);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}
