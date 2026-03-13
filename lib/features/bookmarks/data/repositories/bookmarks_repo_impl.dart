import 'package:jobhub_flutter/core/common/models/job_model.dart';

import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/api_endpoints.dart';
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
        endPoint: ApiEndpoints.bookmarks,
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
        endPoint: "${ApiEndpoints.bookmarks}/$bookmarkJobId",
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
      final raw = await _apiServices.get(
        endPoint: ApiEndpoints.bookmarks,
      );
      final bookmarkedJobs = raw is Map ? raw['data'] : raw;
      if (bookmarkedJobs is! List) return [];
      return bookmarkedJobs
          .map((bookmark) => Map<String, dynamic>.from(bookmark))
          .map((bookmark) => bookmark['job'])
          .whereType<Map>()
          .map((job) => JobModel.fromMap(Map<String, dynamic>.from(job)))
          .toList();
    } catch (e) {
      Logger.logEvent(
        className: "BookmarksRepoImpl",
        event: handleServerError(e),
        methodName: "getBookmarkedJobs",
      );
      throw handleServerError(e);
    }
  }

  @override
  Future<bool> isBookmarked(String jobId) async {
    try {
      final jobs = await getBookmarkedJobs();
      return jobs.any((job) => job.id == jobId);
    } catch (_) {
      return false;
    }
  }
}
