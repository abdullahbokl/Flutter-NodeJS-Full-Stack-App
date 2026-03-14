import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/app_chip.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
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
  final _filters = const ['All', 'Remote', 'Onsite', 'Full-time', 'Part-time'];

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: RefreshIndicator(
        onRefresh: () async => context.read<HomeCubit>().loadJobs(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _Header(onJobsTap: () => context.go(AppRouter.jobsListPage)),
                    const SizedBox(height: AppSpacing.lg),
                    _HeroPanel(onSearchTap: () => context.go(AppRouter.jobsListPage)),
                    const SizedBox(height: AppSpacing.lg),
                    if (!AppSession.isCompany) ...[
                      _QuickActions(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    PremiumSectionHeader(
                      eyebrow: 'Featured',
                      title: 'Curated opportunities',
                      subtitle: 'Hand-picked roles with strong signal and cleaner details.',
                      actionLabel: 'See all',
                      onAction: () => context.push('/jobs', extra: 'All Jobs'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FeaturedJobsList(),
                    const SizedBox(height: AppSpacing.lg),
                    const PremiumSectionHeader(
                      eyebrow: 'Browse',
                      title: 'Recent jobs',
                      subtitle: 'Use quick filters or open the full jobs page for deeper discovery.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          final filter = _filters[index];
                          return AppChip(
                            label: filter,
                            isSelected: _filter == filter,
                            onTap: () => setState(() => _filter = filter),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                        itemCount: _filters.length,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
            _RecentJobsList(filter: _filter),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onJobsTap;

  const _Header({required this.onJobsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(
                AppSession.isCompany ? 'Manage your hiring pipeline' : 'Find a role worth applying for',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        IconButton(onPressed: onJobsTap, icon: const Icon(Icons.work_outline_rounded)),
        AppAvatar(
          radius: 22,
          fallbackInitials: 'U',
          onTap: () => context.push(AppRouter.profilePage),
        ),
      ],
    ).animate().fadeIn().slideY(begin: -0.08);
  }
}

class _HeroPanel extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _HeroPanel({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: const LinearGradient(
        colors: [Color(0xFF0F7C78), Color(0xFF193D5B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Search premium opportunities in one sharper workflow.',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '1,240+ live roles',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Clearer search, richer cards, and faster access to applications, messages, and saved jobs.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumSearchBar(
            hint: 'Search by title, company, or skill',
            onTap: onSearchTap,
            trailing: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE7B75F), Color(0xFFF6DDA5)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.north_east_rounded),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 90.ms).slideY(begin: 0.05);
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PremiumStatCard(
            label: 'Applications',
            value: 'Track',
            icon: Icons.assignment_outlined,
            color: Theme.of(context).colorScheme.primary,
            caption: 'View progress',
            onTap: () => context.push(AppRouter.myApplicationsPage),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PremiumStatCard(
            label: 'Messages',
            value: 'Open',
            icon: Icons.chat_bubble_outline_rounded,
            color: Theme.of(context).colorScheme.secondary,
            caption: 'Reply faster',
            onTap: () => context.push(AppRouter.chatPage),
          ),
        ),
      ],
    );
  }
}

class _FeaturedJobsList extends StatelessWidget {
  const _FeaturedJobsList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: BlocBuilder<HomeCubit, BaseState<List<JobModel>>>(
        builder: (context, state) {
          if (state is LoadingState || state is InitialState) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, __) => const SizedBox(width: 260, child: GlassPanel(child: SizedBox.expand())),
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemCount: 3,
            );
          }
          if (state is! SuccessState<List<JobModel>>) return const SizedBox.shrink();
          final jobs = state.data.take(6).toList();
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, index) => _FeaturedCard(job: jobs[index]),
          );
        },
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final JobModel job;

  const _FeaturedCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: AppCard(
        onTap: () => context.push('/jobs/${job.id}', extra: job),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(radius: 24, fallbackInitials: job.company, imageUrl: job.imageUrl),
                const Spacer(),
                StatusBadge.contract(job.contract),
              ],
            ),
            const Spacer(),
            Text(job.title, style: Theme.of(context).textTheme.titleLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: AppSpacing.xs),
            Text(job.company, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(job.location, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('\$${job.salary}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _RecentJobsList extends StatelessWidget {
  final String filter;

  const _RecentJobsList({required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, BaseState<List<JobModel>>>(
      builder: (context, state) {
        if (state is! SuccessState<List<JobModel>>) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        var jobs = state.data;
        if (filter != 'All') {
          jobs = jobs.where((job) {
            final f = filter.toLowerCase();
            return job.contract.toLowerCase().contains(f) || job.location.toLowerCase().contains(f);
          }).toList();
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: jobs.length,
            itemBuilder: (_, index) => _JobListCard(job: jobs[index]).animate().fadeIn(delay: (40 * index).ms).slideY(begin: 0.04),
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          ),
        );
      },
    );
  }
}

class _JobListCard extends StatelessWidget {
  final JobModel job;

  const _JobListCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/jobs/${job.id}', extra: job),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(radius: 24, fallbackInitials: job.company, imageUrl: job.imageUrl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(job.company, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Text('\$${job.salary}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              StatusBadge.contract(job.contract),
              StatusBadge(label: job.location, variant: BadgeVariant.info),
              StatusBadge(label: job.period, variant: BadgeVariant.neutral),
            ],
          ),
        ],
      ),
    );
  }
}
