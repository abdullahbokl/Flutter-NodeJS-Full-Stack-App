import 'package:flutter/cupertino.dart';

import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../bookmarks/data/repositories/bookmarks_repo_impl.dart';

class JobDetailsProvider extends ChangeNotifier {
  JobDetailsProvider() {
    _logger("JobDetailsProvider initialized");
  }

  bool _isLoading = false;
  bool _isBookmarked = false;
  final ApiServices _apiServices = getIt<ApiServices>();
  final _bookmarksRepoImpl = getIt<BookmarksRepoImpl>();

  // getters
  bool get isLoading => _isLoading;

  bool get isBookmarked => _isBookmarked;

  // setters
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isBookmarked(bool value) {
    _isBookmarked = value;
    notifyListeners();
  }

  Widget getBookmarkIcon() {
    if (_isBookmarked) {
      return const Icon(CupertinoIcons.bookmark_fill, color: AppColors.orange);
    } else {
      return const Icon(CupertinoIcons.bookmark, color: AppColors.orange);
    }
  }

  // methods
  checkIfJobIsBookmarked(String id) async {
    final userId = await AppConstants.getCurrentUserId();
    final userData = await _apiServices
        .get(endPoint: "${AppStrings.apiUsersUrl}/$userId")
        .timeout(const Duration(seconds: 10));
    final List<dynamic> bookmarks = userData[AppStrings.userBookmarks];
    for (final bookmark in bookmarks) {
      if (bookmark[AppStrings.bookmarkJobId] == id) {
        isBookmarked = true;
        break;
      }
    }
    isLoading = false;
  }

  changeBookmarkStatus(
      {required String id, required BuildContext context}) async {
    isLoading = true;
    if (_isBookmarked) {
      await _removeBookmark(id, context);
    } else {
      await _addBookmark(id, context);
    }
    isLoading = false;
  }

  _addBookmark(String id, BuildContext context) async {
    try {
      await _bookmarksRepoImpl.addBookmark(id);
      isBookmarked = true;
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: 'Job bookmarked successfully',
          isSuccess: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: e.toString(),
        );
      }
    }
  }

  _removeBookmark(String id, BuildContext context) async {
    try {
      await _bookmarksRepoImpl.removeBookmark(id);
      isBookmarked = false;
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: 'Job removed from bookmarks',
          isSuccess: true,
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: e.toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    _logger("JobDetailsProvider disposed");
    super.dispose();
  }

  void _logger(String e) {
    Logger.logEvent(
      className: "JobDetailsProvider",
      event: e,
    );
  }
}
