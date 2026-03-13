import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../data/repositories/bookmarks_repo.dart';

class AddBookmarkParams {
  final String jobId;

  const AddBookmarkParams(this.jobId);
}

class AddBookmarkUseCase implements UseCase<void, AddBookmarkParams> {
  final BookmarksRepo _repository;

  const AddBookmarkUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(AddBookmarkParams params) async {
    try {
      await _repository.addBookmark(params.jobId);
      return const Right(null);
    } catch (error) {
      return Left(mapToFailure(error));
    }
  }
}

