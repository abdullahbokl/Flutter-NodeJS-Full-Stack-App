import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/common/widgets/app_avatar.dart';
import '../../../../../core/common/widgets/app_card.dart';
import '../../../../../core/common/widgets/status_badge.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/job_entity.dart';
import 'components/job_actions_menu.dart';

class JobListItem extends StatelessWidget {
  final JobEntity job;
  final bool isMine;

  const JobListItem({
    super.key,
    required this.job,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: AppCard(
          shadowLevel: AppCardShadowLevel.none,
          onTap: () => context.push('/jobs/${job.id}', extra: job),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppAvatar(
                    radius: 24,
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (isMine) JobActionsMenu(job: job),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  StatusBadge.contract(job.contract),
                  StatusBadge(
                    label: job.location,
                    variant: BadgeVariant.info,
                  ),
                  if (job.isArchived)
                    const StatusBadge(
                      label: 'Archived',
                      variant: BadgeVariant.warning,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    '\$${job.salary}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    job.period,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
