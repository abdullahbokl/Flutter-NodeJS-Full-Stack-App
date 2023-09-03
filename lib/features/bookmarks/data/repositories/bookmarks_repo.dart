import '../../../../core/common/models/job_model.dart';

abstract class BookmarksRepo {
  Future<void> addBookmark(String bookmarkJobId);

  Future<void> removeBookmark(String bookmarkJobId);

  Future<List<JobModel>> getBookmarkedJobs();
}
