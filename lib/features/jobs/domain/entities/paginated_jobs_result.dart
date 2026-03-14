import 'package:equatable/equatable.dart';

import 'job_entity.dart';

class PaginatedJobsResult extends Equatable {
  final List<JobEntity> jobs;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedJobsResult({
    required this.jobs,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [jobs, page, limit, total, totalPages];
}
