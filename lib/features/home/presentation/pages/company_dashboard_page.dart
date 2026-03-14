import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/theme/app_radius.dart';
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
      (_) => setState(() {
        _jobsCount = 0;
        _isLoadingJobsCount = false;
      }),
      (jobs) => setState(() {
        _jobsCount = jobs.length;
        _isLoadingJobsCount = false;
      }),
    );
  }

  Future<void> _loadApplicationsCount() async {
    setState(() => _isLoadingApplicationsCount = true);
    try {
      final raw = await getIt<ApiServices>().get(endPoint: '${ApiEndpoints.applications}/received');
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
    return PremiumScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(AppRouter.postJobPage);
          await _loadDashboardStats();
        },
        label: const Text('Post Job'),
        icon: const Icon(Icons.add_rounded),
      ),
      child: RefreshIndicator(
        onRefresh: _loadDashboardStats,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            PageHeader(
              eyebrow: 'Company',
              title: 'Hiring dashboard',
              subtitle: 'Track openings, applicants, and next actions from one clean surface.',
              actions: [
                PageHeaderAction.icon(
                  onPressed: () => context.push(AppRouter.profilePage),
                  icon: Icons.account_circle_outlined,
                  tooltip: 'Profile',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF103D5B), Color(0xFF0F7C78)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep your hiring engine moving',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Review candidates, publish new roles, and revisit older conversations without leaving the dashboard.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.78)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.insights_rounded, color: Colors.white, size: 42),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DashboardMetricBlock(
                        label: 'Active Jobs',
                        value: _isLoadingJobsCount ? '...' : '$_jobsCount',
                        icon: Icons.work_outline_rounded,
                        color: AppColors.primary,
                        caption: 'Currently posted',
                      ),
                      _MetricDivider(),
                      _DashboardMetricBlock(
                        label: 'New Applicants',
                        value: _isLoadingApplicationsCount ? '...' : '$_applicationsCount',
                        icon: Icons.groups_2_outlined,
                        color: AppColors.accent,
                        caption: 'Received applications',
                      ),
                      _MetricDivider(),
                      _DashboardMetricBlock(
                        label: 'Unread Messages',
                        value: 'Open',
                        icon: Icons.mark_chat_unread_outlined,
                        color: AppColors.info,
                        caption: 'Jump into chats',
                        onTap: () => context.push(AppRouter.chatPage),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const PremiumSectionHeader(
              eyebrow: 'Actions',
              title: 'Run the next hiring step',
              subtitle: 'Everything below preserves the current business logic and routes.',
            ),
            const SizedBox(height: AppSpacing.md),
            _ActionTile(
              title: 'Post a New Job',
              subtitle: 'Create a fresh opening and start receiving candidates.',
              icon: Icons.add_business_outlined,
              onTap: () async {
                await context.push(AppRouter.postJobPage);
                await _loadDashboardStats();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _ActionTile(
              title: 'Manage Jobs',
              subtitle: 'Edit, archive, or review your posted openings.',
              icon: Icons.view_kanban_outlined,
              onTap: () async {
                await context.push(AppRouter.manageJobsPage);
                await _loadDashboardStats();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _ActionTile(
              title: 'Review Applications',
              subtitle: 'See applicants, update status, and message top candidates.',
              icon: Icons.fact_check_outlined,
              onTap: () async {
                await context.push(AppRouter.companyApplicationsPage);
                await _loadDashboardStats();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _ActionTile(
              title: 'Open Messages',
              subtitle: 'Resume candidate conversations right away.',
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () => context.push(AppRouter.chatPage),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardMetricBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String caption;
  final VoidCallback? onTap;

  const _DashboardMetricBlock({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.caption,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: 208,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: RadialGradient(
          center: const Alignment(-0.9, -0.1),
          radius: 1.3,
          colors: [
            color.withValues(alpha: 0.16),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withValues(alpha: 0.22),
                            color.withValues(alpha: 0.06),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: color, size: 26),
                    ),
                    if (value.trim().isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        value,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: color,
                              height: 1,
                            ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      color: AppColors.cardBorder.withValues(alpha: 0.6),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
