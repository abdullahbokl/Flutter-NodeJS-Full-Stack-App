import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/bookmarks_repo.dart';

class RemoveBookmarkParams {
  final String jobId;

  const RemoveBookmarkParams(this.jobId);
}

class RemoveBookmarkUseCase implements UseCase<void, RemoveBookmarkParams> {
  final BookmarksRepo _repository;

  const RemoveBookmarkUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(RemoveBookmarkParams params) async {
    try {
      await _repository.removeBookmark(params.jobId);
      return const Right(null);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

