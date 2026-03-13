import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../chat/data/models/chat_model.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';

class CompanyApplicationsPage extends StatefulWidget {
  const CompanyApplicationsPage({super.key});

  @override
  State<CompanyApplicationsPage> createState() => _CompanyApplicationsPageState();
}

class _CompanyApplicationsPageState extends State<CompanyApplicationsPage> {
  bool _isLoading = true;
  List<_ReceivedApplication> _applications = const [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final data = await getIt<ApiServices>().get(
        endPoint: '${ApiEndpoints.applications}/received',
      );
      final list = data is Map ? data['data'] : data;
      if (list is List) {
        _applications = list
            .map((e) => _ReceivedApplication.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        _applications = const [];
      }
    } catch (e) {
      if (mounted) {
        AppSnackBars.showError(context, e.toString());
      }
      _applications = const [];
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _messageApplicant(_ReceivedApplication app) async {
    ChatModel? chat;

    try {
      chat = await _findExistingApplicationChat(app);
    } catch (_) {
      // Fallback to create/access flow below.
    }

    if (chat == null) {
      final chatCubit = getIt<ChatCubit>();
      chat = await chatCubit.createOrGetChat(
        app.applicant.id,
        jobId: app.job.id,
      );
      await chatCubit.close();
    }

    if (!mounted) return;

    if (chat == null) {
      AppSnackBars.showError(context, 'Failed to open chat with applicant');
      return;
    }

    context.push('/chat/${chat.id}', extra: chat);
  }

  Future<ChatModel?> _findExistingApplicationChat(
    _ReceivedApplication app,
  ) async {
    final raw = await getIt<ApiServices>().get(endPoint: ApiEndpoints.chats);
    final list = raw is Map ? raw['data'] : raw;
    if (list is! List) return null;

    for (final item in list) {
      final chat = ChatModel.fromMap(Map<String, dynamic>.from(item));
      final hasApplicant = chat.users.any((u) => u.id == app.applicant.id);
      final sameJob = chat.jobId != null && chat.jobId == app.job.id;
      if (hasApplicant && sameJob) {
        return chat;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        actions: [
          IconButton(
            onPressed: _loadApplications,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _applications.isEmpty
              ? const Center(child: Text('No applications yet'))
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: _applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final app = _applications[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    app.job.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                _StatusChip(status: app.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Applicant: ${app.applicant.displayName}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Job: ${app.job.company} • ${app.job.location}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (app.coverLetter.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                app.coverLetter,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () => _messageApplicant(app),
                                icon: const Icon(Icons.chat_bubble_outline),
                                label: const Text('Message'),
                              ),
                            ),
                          ],
                        ),
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

class _ReceivedApplication {
  final String id;
  final String status;
  final String coverLetter;
  final _Applicant applicant;
  final _Job job;

  const _ReceivedApplication({
    required this.id,
    required this.status,
    required this.coverLetter,
    required this.applicant,
    required this.job,
  });

  factory _ReceivedApplication.fromMap(Map<String, dynamic> map) {
    return _ReceivedApplication(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      status: (map['status'] ?? 'pending').toString(),
      coverLetter: (map['coverLetter'] ?? '').toString(),
      applicant: _Applicant.fromMap(
        map['applicantId'] is Map
            ? Map<String, dynamic>.from(map['applicantId'])
            : <String, dynamic>{},
      ),
      job: _Job.fromMap(
        map['jobId'] is Map
            ? Map<String, dynamic>.from(map['jobId'])
            : <String, dynamic>{},
      ),
    );
  }
}

class _Applicant {
  final String id;
  final String fullName;
  final String userName;

  const _Applicant({
    required this.id,
    required this.fullName,
    required this.userName,
  });

  String get displayName {
    final name = fullName.trim();
    if (name.isNotEmpty) return name;
    final user = userName.trim();
    if (user.isNotEmpty) return user;
    return 'Applicant';
  }

  factory _Applicant.fromMap(Map<String, dynamic> map) {
    return _Applicant(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      userName: (map['userName'] ?? '').toString(),
    );
  }
}

class _Job {
  final String id;
  final String title;
  final String company;
  final String location;

  const _Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
  });

  factory _Job.fromMap(Map<String, dynamic> map) {
    return _Job(
      id: (map['id'] ?? map['_id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      company: (map['company'] ?? '').toString(),
      location: (map['location'] ?? '').toString(),
    );
  }
}


