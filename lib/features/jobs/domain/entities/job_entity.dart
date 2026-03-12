/// Pure domain entity — no Flutter, no JSON.
class JobEntity {
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
  });

  static JobEntity fromMap(dynamic d) => JobEntity(
    id: d['id'] ?? d['_id'] ?? '',
    title: d['title'] ?? '',
    description: d['description'] ?? '',
    location: d['location'] ?? '',
    salary: d['salary'] ?? '',
    company: d['company'] ?? '',
    period: d['period'] ?? '',
    contract: d['contract'] ?? '',
    requirements: List<String>.from(d['requirements'] ?? []),
    imageUrl: d['imageUrl'],
    agentId: d['agentId'] ?? '',
  );
}

