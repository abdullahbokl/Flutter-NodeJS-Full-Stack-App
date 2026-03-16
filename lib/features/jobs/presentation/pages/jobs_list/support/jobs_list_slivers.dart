import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/common/base_state.dart';
import '../../../../../../core/common/widgets/empty_state_widget.dart';
import '../../../../../../core/common/widgets/error_state_widget.dart';
import '../../../../../../core/common/widgets/premium_ui.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/utils/app_colors.dart';
import '../../../../domain/entities/job_entity.dart';
import '../../../widgets/jobs_list/job_list_item.dart';

Widget buildJobsListSliver({
  required BaseState<List<JobEntity>> state,
  required bool isMine,
  required VoidCallback onRetry,
  required ValueListenable<bool>? isLoadingMoreListenable,
}) {
  return switch (state) {
    InitialState<List<JobEntity>>() ||
    LoadingState<List<JobEntity>>() =>
      const _JobsLoadingSliver(),
    SuccessState<List<JobEntity>>(data: final jobs) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == jobs.length) {
                return _JobsListFooter(
                  isLoadingMoreListenable: isLoadingMoreListenable,
                );
              }
              return JobListItem(job: jobs[index], isMine: isMine);
            },
            childCount: jobs.length + 1,
          ),
        ),
      ),
    EmptyState<List<JobEntity>>() => SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Center(
            child: EmptyStateWidget(
              title: 'No jobs found',
              subtitle: isMine
                  ? 'Your posted jobs will appear here.'
                  : 'Try changing filters or search terms.',
              icon: Icons.work_outline_rounded,
              actionLabel: 'Refresh',
              onAction: onRetry,
            ),
          ),
        ),
      ),
    ErrorState<List<JobEntity>>(message: final message) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: ErrorStateWidget(message: message, onRetry: onRetry),
        ),
      ),
  };
}

class _JobsLoadingSliver extends StatelessWidget {
  const _JobsLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: SizedBox(
          width: 180,
          child: GlassPanel(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 12),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JobsListFooter extends StatelessWidget {
  final ValueListenable<bool>? isLoadingMoreListenable;

  const _JobsListFooter({
    required this.isLoadingMoreListenable,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMoreListenable == null) {
      return const SizedBox(height: AppSpacing.md);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: isLoadingMoreListenable!,
      builder: (_, isLoadingMore, __) {
        if (!isLoadingMore) {
          return const SizedBox(height: AppSpacing.md);
        }

        return const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }
}
