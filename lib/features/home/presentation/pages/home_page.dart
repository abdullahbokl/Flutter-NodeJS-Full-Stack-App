import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_chip.dart';

import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../bloc/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();
  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  String _filter = 'All';
  final _filters = ['All', 'Remote', 'Onsite', 'Full-time', 'Part-time'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async => context.read<HomeCubit>().loadJobs(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildStatsBanner()),
              SliverToBoxAdapter(child: _buildQuickActions(context)),
              SliverToBoxAdapter(child: _buildSectionTitle(
                context, 'Featured Jobs', actionLabel: 'See All',
                onAction: () => context.push('/jobs', extra: 'All Jobs'))),
              SliverToBoxAdapter(child: _FeaturedJobsList()),
              SliverToBoxAdapter(child: _buildFilterChips()),
              SliverToBoxAdapter(child: _buildSectionTitle(context, 'Recent Jobs')),
              _RecentJobsList(filter: _filter),
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Good morning! 👋',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary)),
          Text('Find your job',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700)),
        ])),
        IconButton(icon: const Icon(Icons.search_rounded, size: 26),
            onPressed: () => context.go('/search')),
        const SizedBox(width: 4),
        AppAvatar(radius: 20, fallbackInitials: 'U',
            onTap: () => context.push('/profile')),
      ]),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildStatsBanner() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: const Row(children: [
        Icon(Icons.work_outline_rounded, color: Colors.white, size: 28),
        SizedBox(width: AppSpacing.md),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('1,240+ Jobs Available',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
          Text('New listings added daily',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      ]),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05);
  }

  Widget _buildQuickActions(BuildContext context) {
    if (AppSession.isCompany) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push(AppRouter.myApplicationsPage),
              icon: const Icon(Icons.work_history_rounded),
              label: const Text('My Applications'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push(AppRouter.chatPage),
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Messages'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _filters.map((f) => Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: AppChip(label: f, isSelected: _filter == f,
              onTap: () => setState(() => _filter = f)),
        )).toList()),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title,
      {String? actionLabel, VoidCallback? onAction}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700)),
        if (actionLabel != null)
          GestureDetector(onTap: onAction,
            child: Text(actionLabel, style: const TextStyle(
                color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

// ─── Featured Jobs (horizontal scroll) ───────────────────────────────────────
class _FeaturedJobsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: BlocBuilder<HomeCubit, BaseState<List<JobModel>>>(
        builder: (_, state) {
          if (state is LoadingState || state is InitialState) {
            return _HorizontalShimmer();
          }
          if (state is! SuccessState<List<JobModel>>) return const SizedBox.shrink();
          final jobs = state.data.take(6).toList();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (ctx, i) => _FeaturedCard(job: jobs[i], index: i),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final JobModel job;
  final int index;
  const _FeaturedCard({required this.job, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/jobs/${job.id}', extra: job),
      child: Container(
        width: 230,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.accent.withValues(alpha: 0.9),
            ],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                AppAvatar(radius: 22, fallbackInitials: job.company, imageUrl: job.imageUrl),
                StatusBadge.contract(job.contract),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(job.title, style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w700, fontSize: 15),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(job.company, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: AppSpacing.xs),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 12, color: Colors.white70),
                  const SizedBox(width: 3),
                  Expanded(child: Text(job.location,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
              ]),
            ]),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.1);
  }
}

// ─── Recent Jobs (vertical list) ─────────────────────────────────────────────
class _RecentJobsList extends StatelessWidget {
  final String filter;
  const _RecentJobsList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, BaseState<List<JobModel>>>(
      builder: (ctx, state) {
        if (state is! SuccessState<List<JobModel>>) return const SliverToBoxAdapter(child: SizedBox.shrink());
        final filtered = filter == 'All' ? state.data
            : state.data.where((j) =>
                j.contract.toLowerCase().contains(filter.toLowerCase()) ||
                j.location.toLowerCase().contains(filter.toLowerCase())).toList();
        return SliverList(delegate: SliverChildBuilderDelegate(
          (_, i) => _JobListTile(job: filtered[i])
              .animate().fadeIn(delay: Duration(milliseconds: 50 * i)),
          childCount: filtered.length,
        ));
      },
    );
  }
}

class _JobListTile extends StatelessWidget {
  final JobModel job;
  const _JobListTile({required this.job});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        onTap: () => context.push('/jobs/${job.id}', extra: job),
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
            ]),
          ])),
          Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${job.salary}',
                    style: const TextStyle(fontWeight: FontWeight.w700,
                        color: AppColors.primary, fontSize: 14)),
                Text('/${job.period}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
        ]),
      ),
    );
  }
}

class _HorizontalShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(width: 230, height: 180,
            decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl))),
      ),
    );
  }
}
