import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_bookmark_usecase.dart';
import '../../domain/usecases/check_bookmark_usecase.dart';
import '../../domain/usecases/remove_bookmark_usecase.dart';

/// States for a single job's bookmark status (used on job detail screens).
sealed class BookmarkStatusState {
  const BookmarkStatusState();
}

class BookmarkStatusInitial extends BookmarkStatusState {
  const BookmarkStatusInitial();
}

class BookmarkStatusLoading extends BookmarkStatusState {
  final bool isToggling;
  const BookmarkStatusLoading({this.isToggling = false});
}

class BookmarkStatusLoaded extends BookmarkStatusState {
  final bool isBookmarked;
  const BookmarkStatusLoaded(this.isBookmarked);
}

class BookmarkStatusToggled extends BookmarkStatusState {
  final bool isBookmarked;
  final String message;
  const BookmarkStatusToggled(this.isBookmarked, this.message);
}

class BookmarkStatusError extends BookmarkStatusState {
  final String message;
  const BookmarkStatusError(this.message);
}

/// Manages the bookmark status for a single job.
/// Replaces JobDetailsProvider's bookmark logic.
class BookmarkStatusCubit extends Cubit<BookmarkStatusState> {
  final CheckBookmarkUseCase _checkBookmark;
  final AddBookmarkUseCase _addBookmark;
  final RemoveBookmarkUseCase _removeBookmark;

  BookmarkStatusCubit({
    required CheckBookmarkUseCase checkBookmark,
    required AddBookmarkUseCase addBookmark,
    required RemoveBookmarkUseCase removeBookmark,
  })  : _checkBookmark = checkBookmark,
        _addBookmark = addBookmark,
        _removeBookmark = removeBookmark,
        super(const BookmarkStatusInitial());

  /// Check if a job is bookmarked.
  Future<void> check(String jobId) async {
    emit(const BookmarkStatusLoading(isToggling: false));
    final result = await _checkBookmark(CheckBookmarkParams(jobId));
    result.fold(
      (failure) => emit(BookmarkStatusError(failure.message)),
      (isBookmarked) => emit(BookmarkStatusLoaded(isBookmarked)),
    );
  }

  /// Toggle bookmark status.
  Future<void> toggle(String jobId) async {
    final wasBookmarked =
        (state is BookmarkStatusLoaded && (state as BookmarkStatusLoaded).isBookmarked) ||
        (state is BookmarkStatusToggled && (state as BookmarkStatusToggled).isBookmarked);

    emit(const BookmarkStatusLoading(isToggling: true));

    if (wasBookmarked) {
      final result = await _removeBookmark(RemoveBookmarkParams(jobId));
      result.fold(
        (failure) => emit(BookmarkStatusError(failure.message)),
        (_) => emit(const BookmarkStatusToggled(false, 'Job removed from bookmarks')),
      );
    } else {
      final result = await _addBookmark(AddBookmarkParams(jobId));
      result.fold(
        (failure) => emit(BookmarkStatusError(failure.message)),
        (_) => emit(const BookmarkStatusToggled(true, 'Job bookmarked successfully')),
      );
    }
  }
}
