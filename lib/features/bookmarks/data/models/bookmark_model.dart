import '../../../../core/utils/app_strings.dart';

class BookmarkModel {
  final String jobId;
  final String? createdAt;

  BookmarkModel({
    required this.jobId,
    this.createdAt,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> json) => BookmarkModel(
        jobId: json[AppStrings.bookmarkJobId],
        createdAt: json[AppStrings.bookmarkCreatedAt],
      );

  Map<String, dynamic> toMap() => {
        AppStrings.bookmarkJobId: jobId,
        AppStrings.bookmarkCreatedAt: createdAt,
      };
}
