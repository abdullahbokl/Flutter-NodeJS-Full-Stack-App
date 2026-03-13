import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../domain/usecases/add_bookmark_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import '../../domain/usecases/remove_bookmark_usecase.dart';

class BookmarksCubit extends Cubit<BaseState<List<JobModel>>> {
  final GetBookmarksUseCase _getBookmarks;
  final AddBookmarkUseCase _addBookmark;
  final RemoveBookmarkUseCase _removeBookmark;

  BookmarksCubit({
    required GetBookmarksUseCase getBookmarks,
    required AddBookmarkUseCase addBookmark,
    required RemoveBookmarkUseCase removeBookmark,
  })  : _getBookmarks = getBookmarks,
        _addBookmark = addBookmark,
        _removeBookmark = removeBookmark,
        super(const InitialState());

  Future<void> loadBookmarks() async {
    emit(const LoadingState());
    final result = await _getBookmarks(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }

  Future<void> addBookmark(String jobId) async {
    final result = await _addBookmark(AddBookmarkParams(jobId));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (_) => loadBookmarks(),
    );
  }

  Future<void> removeBookmark(String jobId) async {
    // Optimistic update: remove immediately from list
    if (state is SuccessState<List<JobModel>>) {
      final prev = (state as SuccessState<List<JobModel>>).data;
      final updated = prev.where((j) => j.id != jobId).toList();
      emit(updated.isEmpty ? const EmptyState() : SuccessState(updated));
    }
    final result = await _removeBookmark(RemoveBookmarkParams(jobId));
    result.fold(
      // On failure: reload from server to restore the real list
      (failure) => loadBookmarks(),
      // On success: re-sync from server to stay consistent
      (_) => loadBookmarks(),
    );
  }
}

