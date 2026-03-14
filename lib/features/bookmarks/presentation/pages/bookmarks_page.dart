import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../bloc/bookmarks_cubit.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: BlocBuilder<BookmarksCubit, BaseState<List<JobModel>>>(
        builder: (context, state) => BlocStateWidget<List<JobModel>>(
          state: state,
          emptyTitle: 'No saved jobs',
          emptySubtitle: 'Bookmark jobs you want to revisit and they will appear here.',
          emptyIcon: Icons.bookmark_border_rounded,
          onRetry: () => context.read<BookmarksCubit>().loadBookmarks(),
          onSuccess: (jobs) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: jobs.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, index) {
              if (index == 0) {
                return PageHeader(
                  eyebrow: 'Saved',
                  title: 'Bookmarked jobs',
                  subtitle: 'A cleaner shortlist of roles you may want to return to.',
                  actions: [
                    PageHeaderAction.text(
                      onPressed: () => context.read<BookmarksCubit>().loadBookmarks(),
                      label: 'Refresh',
                    ),
                  ],
                );
              }

              final job = jobs[index - 1];
              return Dismissible(
                key: Key(job.id),
                direction: DismissDirection.endToStart,
                background: AppCard(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete_outline_rounded, color: Colors.red),
                  ),
                ),
                onDismissed: (_) {
                  context.read<BookmarksCubit>().removeBookmark(job.id);
                  AppSnackBars.showInfo(
                    context,
                    'Removed from bookmarks',
                    actionLabel: 'Undo',
                    onAction: () => context.read<BookmarksCubit>().addBookmark(job.id),
                  );
                },
                child: AppCard(
                  onTap: () => context.push('/jobs/${job.id}', extra: job),
                  child: Row(
                    children: [
                      AppAvatar(radius: 24, imageUrl: job.imageUrl, fallbackInitials: job.company),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(job.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(job.company, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                StatusBadge.contract(job.contract),
                                StatusBadge(label: job.location, variant: BadgeVariant.info),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('\$${job.salary}', style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
