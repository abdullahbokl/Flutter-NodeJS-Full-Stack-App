import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/config/app_router.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../presentation/bloc/jobs_cubit.dart';
import '../../presentation/bloc/manage_jobs_cubit.dart';

class JobsListPage extends StatelessWidget {
  final String? title;
  final bool isMine;

  const JobsListPage({super.key, this.title, this.isMine = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(
              AppSession.isCompany
                  ? AppRouter.companyDashboardPage
                  : AppRouter.homePage,
            );
          },
        ),
        title: Text(title ?? 'Jobs'),
      ),
      body: isMine
          ? BlocBuilder<ManageJobsCubit, BaseState<List<JobEntity>>>(
              builder: (ctx, state) => _buildList(
                  ctx, state, () => ctx.read<ManageJobsCubit>().loadMyJobs()),
            )
          : BlocBuilder<JobsCubit, BaseState<List<JobEntity>>>(
              builder: (ctx, state) => _buildList(
                  ctx, state, () => ctx.read<JobsCubit>().loadJobs()),
            ),
    );
  }

  Widget _buildList(BuildContext context, BaseState<List<JobEntity>> state,
      VoidCallback onRetry) {
    return BlocStateWidget<List<JobEntity>>(
      state: state,
      emptyTitle: 'No jobs found',
      onRetry: onRetry,
      onSuccess: (jobs) => ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: jobs.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final job = jobs[i];
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return InkWell(
            onTap: () => context.push('/jobs/${job.id}', extra: job),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(children: [
                AppAvatar(
                  radius: 26,
                  imageUrl: job.imageUrl,
                  fallbackInitials: job.company,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        job.company,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            job.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        StatusBadge.contract(job.contract),
                      ]),
                    ],
                  ),
                ),
                Text(
                  '\$${job.salary}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
