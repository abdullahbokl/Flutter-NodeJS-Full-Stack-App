import 'package:equatable/equatable.dart';

/// Pure domain entity — no Flutter, no JSON.
class JobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String salary;
  final String company;
  final String period;
  final String contract;
  final List<String> requirements;
  final String? imageUrl;
  final String agentId;
  final bool isArchived;

  const JobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.company,
    required this.period,
    required this.contract,
    this.requirements = const [],
    this.imageUrl,
    required this.agentId,
    this.isArchived = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        salary,
        company,
        period,
        contract,
        requirements,
        imageUrl,
        agentId,
        isArchived,
      ];
}
