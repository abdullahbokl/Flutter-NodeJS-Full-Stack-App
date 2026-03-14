import 'package:equatable/equatable.dart';

class JobFilterParams extends Equatable {
  final String query;
  final String? location;
  final String? contract;
  final String? minSalary;
  final String? maxSalary;
  final bool includeArchived;
  final int page;
  final int limit;

  const JobFilterParams({
    this.query = '',
    this.location,
    this.contract,
    this.minSalary,
    this.maxSalary,
    this.includeArchived = false,
    this.page = 1,
    this.limit = 10,
  });

  bool get isEmpty =>
      query.trim().isEmpty &&
      (location?.trim().isNotEmpty != true) &&
      (contract?.trim().isNotEmpty != true) &&
      (minSalary?.trim().isNotEmpty != true) &&
      (maxSalary?.trim().isNotEmpty != true) &&
      !includeArchived;

  Map<String, dynamic> toQueryParameters() {
    final queryParameters = <String, dynamic>{};
    if (query.trim().isNotEmpty) queryParameters['query'] = query.trim();
    if (location?.trim().isNotEmpty == true) {
      queryParameters['location'] = location!.trim();
    }
    if (contract?.trim().isNotEmpty == true) {
      queryParameters['contract'] = contract!.trim();
    }
    if (minSalary?.trim().isNotEmpty == true) {
      queryParameters['minSalary'] = minSalary!.trim();
    }
    if (maxSalary?.trim().isNotEmpty == true) {
      queryParameters['maxSalary'] = maxSalary!.trim();
    }
    if (includeArchived) {
      queryParameters['includeArchived'] = 'true';
    }
    queryParameters['page'] = '$page';
    queryParameters['limit'] = '$limit';
    return queryParameters;
  }

  JobFilterParams copyWith({
    String? query,
    String? location,
    String? contract,
    String? minSalary,
    String? maxSalary,
    bool? includeArchived,
    int? page,
    int? limit,
  }) {
    return JobFilterParams(
      query: query ?? this.query,
      location: location ?? this.location,
      contract: contract ?? this.contract,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      includeArchived: includeArchived ?? this.includeArchived,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        query,
        location,
        contract,
        minSalary,
        maxSalary,
        includeArchived,
        page,
        limit,
      ];
}
