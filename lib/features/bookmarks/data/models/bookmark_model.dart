import '../../domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.jobId,
    super.createdAt,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> json) => BookmarkModel(
        jobId: json['jobId'],
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toMap() => {
        'jobId': jobId,
        'createdAt': createdAt,
      };
}
