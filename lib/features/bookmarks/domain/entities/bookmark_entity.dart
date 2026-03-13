import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final String jobId;
  final String? createdAt;

  const BookmarkEntity({
    required this.jobId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [jobId, createdAt];
}
