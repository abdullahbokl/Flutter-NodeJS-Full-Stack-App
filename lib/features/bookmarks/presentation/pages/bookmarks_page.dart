import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../bloc/bookmarks_cubit.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookmarksCubit()..loadBookmarks(),
      child: const _BookmarksView(),
    );
  }
}

class _BookmarksView extends StatelessWidget {
  const _BookmarksView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<BookmarksCubit>().loadBookmarks(),
          ),
        ],
      ),
      body: BlocBuilder<BookmarksCubit, BaseState<List<JobModel>>>(
        builder: (ctx, state) => BlocStateWidget<List<JobModel>>(
          state: state,
          emptyTitle: 'No saved jobs',
          emptySubtitle: 'Bookmark jobs you like and they\'ll appear here',
          emptyIcon: Icons.bookmark_border_rounded,
          onRetry: () => ctx.read<BookmarksCubit>().loadBookmarks(),
          onSuccess: (jobs) => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _BookmarkTile(job: jobs[i])
                .animate().fadeIn(delay: Duration(milliseconds: 50 * i)),
          ),
        ),
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final JobModel job;
  const _BookmarkTile({required this.job});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dismissible(
      key: Key(job.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
      ),
      onDismissed: (_) {
        context.read<BookmarksCubit>().removeBookmark(job.id);
        AppSnackBars.showInfo(context, 'Removed from bookmarks',
            actionLabel: 'Undo',
            onAction: () => context.read<BookmarksCubit>().addBookmark(job.id));
      },
      child: InkWell(
        onTap: () => context.go('/jobs/${job.id}', extra: job),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
                blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            AppAvatar(radius: 26, imageUrl: job.imageUrl, fallbackInitials: job.company),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(job.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(job.company,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 3),
                Expanded(child: Text(job.location,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                StatusBadge.contract(job.contract),
              ]),
            ])),
            const SizedBox(width: AppSpacing.sm),
            Text('\$${job.salary}',
                style: const TextStyle(fontWeight: FontWeight.w700,
                    color: AppColors.primary, fontSize: 14)),
          ]),
        ),
      ),
    );
  }
}
