import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/models/user_model.dart';
import '../../domain/entities/application_status.dart';

class JobApplicationModel {
  final String id;
  final String status;
  final String coverLetter;
  final JobModel job;
  final UserModel? applicant;
  final String createdAt;

  const JobApplicationModel({
    required this.id,
    required this.status,
    required this.coverLetter,
    required this.job,
    this.applicant,
    this.createdAt = '',
  });

  JobApplicationModel copyWith({
    String? id,
    String? status,
    String? coverLetter,
    JobModel? job,
    UserModel? applicant,
    String? createdAt,
  }) {
    return JobApplicationModel(
      id: id ?? this.id,
      status: status ?? this.status,
      coverLetter: coverLetter ?? this.coverLetter,
      job: job ?? this.job,
      applicant: applicant ?? this.applicant,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    final rawJob = map['jobId'] is Map
        ? Map<String, dynamic>.from(map['jobId'] as Map)
        : <String, dynamic>{};
    final rawApplicant = map['applicantId'] is Map
        ? Map<String, dynamic>.from(map['applicantId'] as Map)
        : null;
    final requirementsRaw = rawJob['requirements'];
    final requirements = requirementsRaw is List
        ? requirementsRaw.map((item) => item.toString()).toList()
        : const <String>[];

    return JobApplicationModel(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      status: ApplicationStatus.normalize((map['status'] ?? '').toString()),
      coverLetter: (map['coverLetter'] ?? '').toString(),
      createdAt: (map['createdAt'] ?? '').toString(),
      applicant: rawApplicant == null ? null : UserModel.fromMap(rawApplicant),
      job: JobModel(
        id: (rawJob['id'] ?? rawJob['_id'] ?? '').toString(),
        title: (rawJob['title'] ?? '').toString(),
        description: (rawJob['description'] ?? '').toString(),
        location: (rawJob['location'] ?? '').toString(),
        salary: (rawJob['salary'] ?? '').toString(),
        company: (rawJob['company'] ?? '').toString(),
        period: (rawJob['period'] ?? '').toString(),
        contract: (rawJob['contract'] ?? '').toString(),
        requirements: requirements,
        imageUrl: rawJob['imageUrl']?.toString(),
        agentId: (rawJob['agentId'] ?? '').toString(),
        isArchived: rawJob['isArchived'] == true,
      ),
    );
  }
}

