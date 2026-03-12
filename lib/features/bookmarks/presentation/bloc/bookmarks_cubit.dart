import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/app_strings.dart';

class BookmarksCubit extends Cubit<BaseState<List<JobModel>>> {
  BookmarksCubit() : super(const InitialState());

  Future<void> loadBookmarks() async {
    emit(const LoadingState());
    try {
      final raw = await getIt<ApiServices>().get(endPoint: AppStrings.apiBookmarkUrl);
      final list = _parse(raw);
      emit(list.isEmpty ? const EmptyState() : SuccessState(list));
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  Future<void> addBookmark(String jobId) async {
    try {
      await getIt<ApiServices>().post(
        endPoint: AppStrings.apiBookmarkUrl,
        data: {AppStrings.bookmarkJobId: jobId},
      );
      loadBookmarks();
    } catch (e) {
      emit(ErrorState(mapToFailure(e).message));
    }
  }

  Future<void> removeBookmark(String jobId) async {
    // Optimistic update
    if (state is SuccessState<List<JobModel>>) {
      final prev = (state as SuccessState<List<JobModel>>).data;
      final updated = prev.where((j) => j.id != jobId).toList();
      emit(updated.isEmpty ? const EmptyState() : SuccessState(updated));
    }
    try {
      await getIt<ApiServices>().delete(
          endPoint: '${AppStrings.apiBookmarkUrl}/$jobId');
    } catch (e) {
      loadBookmarks(); // rollback on error
    }
  }

  static List<JobModel> _parse(dynamic raw) {
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return [];
    return list.map((e) => JobModel.fromMap(e)).toList();
  }
}

