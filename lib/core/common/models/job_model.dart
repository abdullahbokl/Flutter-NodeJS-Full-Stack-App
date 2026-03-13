import '../../../features/jobs/domain/entities/job_entity.dart';


class JobModel extends JobEntity {
  const JobModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.salary,
    required super.company,
    required super.period,
    required super.contract,
    required super.requirements,
    super.imageUrl,
    required super.agentId,
    super.isArchived = false,
  });

  factory JobModel.fromMap(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      salary: json['salary'] ?? '',
      company: json['company'] ?? '',
      period: json['period'] ?? '',
      contract: json['contract'] ?? '',
      requirements: List<String>.from(json['requirements'] ?? []),
      imageUrl: json['imageUrl'],
      agentId: json['agentId'] ?? '',
      isArchived: json['isArchived'] == true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'salary': salary,
        'company': company,
        'period': period,
        'contract': contract,
        'requirements': requirements,
        'imageUrl': imageUrl,
        'agentId': agentId,
        'isArchived': isArchived,
      };
}
