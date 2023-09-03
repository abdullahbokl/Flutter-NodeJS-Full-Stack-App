import 'package:jobhub_flutter/core/common/models/job_model.dart';

import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/bookmark_model.dart';
import 'bookmarks_repo.dart';

class BookmarksRepoImpl implements BookmarksRepo {
  final ApiServices _apiServices;

  BookmarksRepoImpl(this._apiServices);

  @override
  Future<void> addBookmark(String bookmarkJobId) async {
    final bookmarkData = BookmarkModel(jobId: bookmarkJobId).toMap();
    try {
      await _apiServices.post(
        endPoint: AppStrings.apiBookmarkUrl,
        data: bookmarkData,
      );
    } catch (e) {
      Logger.logEvent(
        className: "BookmarksRepoImpl",
        event: handleServerError(e),
        methodName: "addBookmark",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<void> removeBookmark(String bookmarkJobId) {
    try {
      return _apiServices.delete(
        endPoint: "${AppStrings.apiBookmarkUrl}/$bookmarkJobId",
      );
    } catch (e) {
      Logger.logEvent(
        className: "BookmarksRepoImpl",
        event: handleServerError(e),
        methodName: "removeBookmark",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<List<JobModel>> getBookmarkedJobs() async {
    try {
      final List<dynamic> bookmarkedJobs = await _apiServices.get(
        endPoint: AppStrings.apiBookmarkUrl,
      );
      final List<JobModel> bookmarkedJobsList = [];
      for (final bookmarkedJob in bookmarkedJobs) {
        final job = JobModel.fromMap(bookmarkedJob);
        bookmarkedJobsList.add(job);
      }
      return bookmarkedJobsList;
    } catch (e) {
      Logger.logEvent(
        className: "BookmarksRepoImpl",
        event: handleServerError(e),
        methodName: "getBookmarkedJobs",
      );
      throw handleServerError(e);
    }
  }
}
