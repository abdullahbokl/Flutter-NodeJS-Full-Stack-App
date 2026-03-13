import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../jobs/domain/usecases/get_my_jobs_usecase.dart';

class CompanyDashboardPage extends StatefulWidget {
  const CompanyDashboardPage({super.key});

  @override
  State<CompanyDashboardPage> createState() => _CompanyDashboardPageState();
}

class _CompanyDashboardPageState extends State<CompanyDashboardPage> {
  int _jobsCount = 0;
  int _applicationsCount = 0;
  bool _isLoadingJobsCount = true;
  bool _isLoadingApplicationsCount = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  Future<void> _loadDashboardStats() async {
    await Future.wait([_loadJobsCount(), _loadApplicationsCount()]);
  }

  Future<void> _loadJobsCount() async {
    setState(() => _isLoadingJobsCount = true);
    final result = await getIt<GetMyJobsUseCase>()(const NoParams());
    if (!mounted) return;
    result.fold(
      (_) {
        setState(() {
          _jobsCount = 0;
          _isLoadingJobsCount = false;
        });
      },
      (jobs) {
        setState(() {
          _jobsCount = jobs.length;
          _isLoadingJobsCount = false;
        });
      },
    );
  }

  Future<void> _loadApplicationsCount() async {
    setState(() => _isLoadingApplicationsCount = true);
    try {
      final raw = await getIt<ApiServices>().get(
        endPoint: '${ApiEndpoints.applications}/received',
      );
      final list = raw is Map ? raw['data'] : raw;
      if (!mounted) return;
      setState(() {
        _applicationsCount = list is List ? list.length : 0;
        _isLoadingApplicationsCount = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _applicationsCount = 0;
        _isLoadingApplicationsCount = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            onPressed: _loadDashboardStats,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DashboardCard(
              title: 'Jobs Posted',
              value: _isLoadingJobsCount ? '...' : '$_jobsCount',
              icon: Icons.work_outline,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            _DashboardCard(
              title: 'Applications',
              value: _isLoadingApplicationsCount ? '...' : '$_applicationsCount',
              icon: Icons.people_outline,
              color: AppColors.accent,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              title: const Text('Post a New Job'),
              subtitle: const Text('Start looking for your next hire'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await context.push(AppRouter.postJobPage);
                await _loadDashboardStats();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list_alt, color: AppColors.accent),
              title: const Text('Manage Jobs'),
              subtitle: const Text('Edit or close existing job postings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await context.push(AppRouter.manageJobsPage);
                await _loadDashboardStats();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.people_alt_outlined, color: AppColors.primary),
              title: const Text('Review Applications'),
              subtitle: const Text('See applicants and message them'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await context.push(AppRouter.companyApplicationsPage);
                await _loadDashboardStats();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: AppColors.accent),
              title: const Text('Open Old Chats'),
              subtitle: const Text('Check existing conversations directly'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRouter.chatPage),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRouter.postJobPage);
          await _loadDashboardStats();
        },
        label: const Text('Post Job'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
