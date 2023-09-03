import 'package:flutter/material.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../data/repositories/bookmarks_repo_impl.dart';

class BookMarkProvider extends ChangeNotifier {
  BookMarkProvider() {
    _bookmarksProviderLogger("BookMarkNotifier initialized");
  }

  bool _isLoading = false;
  final _bookmarksRepoImpl = getIt<BookmarksRepoImpl>();
  List<JobModel> _jobs = [];

  // getters
  bool get isLoading => _isLoading;

  List<JobModel> get jobs => _jobs;

  // setters
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  getAllBookmarks() async {
    isLoading = true;
    try {
      _jobs = await _bookmarksRepoImpl.getBookmarkedJobs();
    } catch (e) {
      rethrow;
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _bookmarksProviderLogger("BookMarkNotifier disposed");

    super.dispose();
  }

  _bookmarksProviderLogger(String event) {
    return Logger.logEvent(
      className: "BookMarkNotifier",
      event: "BookMarkNotifier initialized",
    );
  }
}
