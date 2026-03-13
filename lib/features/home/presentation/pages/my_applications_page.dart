import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../../jobs/presentation/pages/job_details_page.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  bool _isLoading = true;
  List<_MyApplication> _applications = const [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final raw = await getIt<ApiServices>().get(
        endPoint: '${ApiEndpoints.applications}/mine',
      );
      final list = raw is Map ? raw['data'] : raw;
      if (list is List) {
        _applications = list
            .map((e) => _MyApplication.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        _applications = const [];
      }
    } catch (_) {
      _applications = const [];
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () => context.push(AppRouter.chatPage),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadApplications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('No applied jobs yet'))
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final app = _applications[i];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        title: Text(
                          app.job.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${app.job.company} • ${app.job.location}',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              _StatusChip(status: app.status),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => JobDetailsPage.page(job: app.job),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'accepted':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      case 'reviewed':
        color = Colors.orange;
        break;
      default:
        color = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MyApplication {
  final String id;
  final String status;
  final JobEntity job;

  const _MyApplication({
    required this.id,
    required this.status,
    required this.job,
  });

  factory _MyApplication.fromMap(Map<String, dynamic> map) {
    final rawJob = map['jobId'] is Map
        ? Map<String, dynamic>.from(map['jobId'])
        : <String, dynamic>{};

    final requirementsRaw = rawJob['requirements'];
    final requirements = requirementsRaw is List
        ? requirementsRaw.map((e) => e.toString()).toList()
        : const <String>[];

    return _MyApplication(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      job: JobEntity(
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
      ),
    );
  }
}

