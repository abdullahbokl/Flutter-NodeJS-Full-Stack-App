import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/usecase.dart';
import '../../domain/usecases/add_bookmark_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import '../../domain/usecases/remove_bookmark_usecase.dart';
class BookmarksCubit extends Cubit<BaseState<List<JobModel>>> {
  final GetBookmarksUseCase getBookmarksUseCase;
  final AddBookmarkUseCase addBookmarkUseCase;
  final RemoveBookmarkUseCase removeBookmarkUseCase;
  BookmarksCubit({
    required this.getBookmarksUseCase,
    required this.addBookmarkUseCase,
    required this.removeBookmarkUseCase,
  }) : super(const InitialState());
  Future<void> loadBookmarks() async {
    emit(const LoadingState());
    final result = await getBookmarksUseCase(const NoParams());
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (jobs) => emit(jobs.isEmpty ? const EmptyState() : SuccessState(jobs)),
    );
  }
  Future<void> addBookmark(String jobId) async {
    final result = await addBookmarkUseCase(AddBookmarkParams(jobId));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (_) => loadBookmarks(),
    );
  }
  Future<void> removeBookmark(String jobId) async {
    final result = await removeBookmarkUseCase(RemoveBookmarkParams(jobId));
    result.fold(
      (failure) => emit(ErrorState(failure.message)),
      (_) => loadBookmarks(),
    );
  }
}
