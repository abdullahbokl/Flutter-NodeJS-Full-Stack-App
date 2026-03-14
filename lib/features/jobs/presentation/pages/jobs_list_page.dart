import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/empty_state_widget.dart';
import '../../../../core/common/widgets/error_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../../core/utils/app_session.dart';
import '../../domain/entities/job_filter_params.dart';
import '../../../jobs/domain/entities/job_entity.dart';
import '../../presentation/bloc/jobs_cubit.dart';
import '../../presentation/bloc/manage_job_action_cubit.dart';
import '../../presentation/bloc/manage_jobs_cubit.dart';

class JobsListPage extends StatelessWidget {
  final String? title;
  final bool isMine;
  final bool autofocusSearch;

  const JobsListPage({
    super.key,
    this.title,
    this.isMine = false,
    this.autofocusSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: isMine
          ? BlocBuilder<ManageJobsCubit, BaseState<List<JobEntity>>>(
              builder: (ctx, state) => _JobsListContent(
                title: title ?? 'My Posted Jobs',
                state: state,
                onRetry: () => ctx.read<ManageJobsCubit>().loadMyJobs(),
                isMine: true,
              ),
            )
          : _BrowseJobsView(
              title: title ?? 'All Jobs',
              autofocusSearch: autofocusSearch,
            ),
    );
  }
}

class _BrowseJobsView extends StatefulWidget {
  final String title;
  final bool autofocusSearch;

  const _BrowseJobsView({
    required this.title,
    required this.autofocusSearch,
  });

  @override
  State<_BrowseJobsView> createState() => _BrowseJobsViewState();
}

class _BrowseJobsViewState extends State<_BrowseJobsView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final JobsCubit _jobsCubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _jobsCubit = context.read<JobsCubit>();
    final filters = _jobsCubit.filters;
    _controller = TextEditingController(text: filters.query);
    _focusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _jobsCubit.loadJobs(const JobFilterParams());
    });
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 240) return;
    setState(() {});
    _jobsCubit.loadMore().whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _openFilters() async {
    final filters = await showModalBottomSheet<JobFilterParams>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FiltersSheet(initialFilters: _jobsCubit.filters),
    );
    if (filters == null || !mounted) return;

    await _jobsCubit.applyFilters(filters.copyWith(query: _controller.text.trim()));
    if (!mounted) return;
    setState(() {});
  }

  void _resetBrowseState() {
    _focusNode.unfocus();
    _controller.clear();
    _jobsCubit.reset();
  }

  void _exitPage() {
    _resetBrowseState();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(
        AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsCubit, BaseState<List<JobEntity>>>(
      builder: (ctx, state) {
        final filters = ctx.read<JobsCubit>().filters;
        return _JobsListContent(
          title: widget.title,
          state: state,
          onRetry: () => ctx.read<JobsCubit>().retry(),
          isMine: false,
          scrollController: _scrollController,
          isLoadingMore: _jobsCubit.isLoadingMore,
          header: _BrowseHeader(
            title: widget.title,
            controller: _controller,
            focusNode: _focusNode,
            autofocusSearch: widget.autofocusSearch,
            filters: filters,
            onChanged: (query) {
              setState(() {});
              ctx.read<JobsCubit>().search(query);
            },
            onClear: () async {
              _controller.clear();
              await ctx.read<JobsCubit>().clearFilters();
              if (!mounted) return;
              setState(() {});
            },
            onFilterTap: _openFilters,
            onBack: _exitPage,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _resetBrowseState();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class _JobsListContent extends StatelessWidget {
  final String title;
  final BaseState<List<JobEntity>> state;
  final VoidCallback onRetry;
  final bool isMine;
  final Widget? header;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const _JobsListContent({
    required this.title,
    required this.state,
    required this.onRetry,
    required this.isMine,
    this.header,
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (header != null && !isMine) {
      return RefreshIndicator(
        onRefresh: () async => onRetry(),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            header!,
            const SizedBox(height: AppSpacing.md),
            _buildBrowseBody(context),
          ],
        ),
      );
    }

    return BlocStateWidget<List<JobEntity>>(
      state: state,
      emptyTitle: 'No jobs found',
      emptySubtitle: isMine ? 'Your posted jobs will appear here.' : 'Try changing filters or search terms.',
      emptyIcon: Icons.work_outline_rounded,
      onRetry: onRetry,
      onSuccess: (jobs) => RefreshIndicator(
        onRefresh: () async => onRetry(),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: jobs.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            if (index == 0) {
              if (header != null) {
                return header!;
              }

              void handleBack() {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(
                    AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage,
                  );
                }
              }

              if (isMine) {
                return PageHeader(
                  eyebrow: 'Management',
                  title: title,
                  subtitle: 'Edit, archive, or review the jobs your company has posted.',
                  leadingAction: PageHeaderAction.icon(
                    onPressed: handleBack,
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                  ),
                );
              }

              return PageHeader(
                eyebrow: 'Open Roles',
                title: title,
                subtitle: 'Browse the latest openings with upgraded card hierarchy.',
                leadingAction: PageHeaderAction.icon(
                  onPressed: handleBack,
                  icon: Icons.arrow_back_rounded,
                  tooltip: 'Back',
                ),
              );
            }

            final job = jobs[index - 1];
            return AppCard(
              onTap: () => context.push('/jobs/${job.id}', extra: job),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          ],
                        ),
                      ),
                      if (isMine) _JobActions(job: job),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      StatusBadge.contract(job.contract),
                      StatusBadge(label: job.location, variant: BadgeVariant.info),
                      if (job.isArchived) const StatusBadge(label: 'Archived', variant: BadgeVariant.warning),
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
                      Text(job.period, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBrowseBody(BuildContext context) {
    return switch (state) {
      InitialState<List<JobEntity>>() || LoadingState<List<JobEntity>>() => const Padding(
          padding: EdgeInsets.only(top: AppSpacing.xxl),
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
        ),
      SuccessState<List<JobEntity>>(data: final jobs) => Column(
          children: [
            ...List.generate(jobs.length, (index) {
              final job = jobs[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index == jobs.length - 1 && !isLoadingMore ? 0 : AppSpacing.md),
                child: AppCard(
                  onTap: () => context.push('/jobs/${job.id}', extra: job),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          StatusBadge.contract(job.contract),
                          StatusBadge(label: job.location, variant: BadgeVariant.info),
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
                          Text(job.period, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),
      EmptyState<List<JobEntity>>() => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl),
          child: EmptyStateWidget(
            title: 'No jobs found',
            subtitle: 'Try changing filters or search terms.',
            icon: Icons.work_outline_rounded,
            actionLabel: 'Refresh',
            onAction: onRetry,
          ),
        ),
      ErrorState<List<JobEntity>>(message: final msg) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl),
          child: ErrorStateWidget(message: msg, onRetry: onRetry),
        ),
    };
  }
}

class _BrowseHeader extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool autofocusSearch;
  final JobFilterParams filters;
  final ValueChanged<String> onChanged;
  final Future<void> Function() onClear;
  final Future<void> Function() onFilterTap;
  final VoidCallback onBack;

  const _BrowseHeader({
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.autofocusSearch,
    required this.filters,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    required this.onBack,
  });

  bool get _hasActiveFilters =>
      (filters.location?.trim().isNotEmpty == true) ||
      (filters.contract?.trim().isNotEmpty == true) ||
      (filters.minSalary?.trim().isNotEmpty == true) ||
      (filters.maxSalary?.trim().isNotEmpty == true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: title,
          leadingAction: PageHeaderAction.icon(
            onPressed: onBack,
            icon: Icons.arrow_back_rounded,
            tooltip: 'Back',
          ),
          density: PageHeaderDensity.compact,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocusSearch,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: 'Search jobs, companies...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: onClear,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      borderSide: BorderSide.none,
                    ),
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            GlassPanel(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: onFilterTap,
                  child: Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: _hasActiveFilters
                          ? LinearGradient(
                              colors: [
                                theme.colorScheme.primary.withValues(alpha: 0.18),
                                theme.colorScheme.primary.withValues(alpha: 0.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          color: _hasActiveFilters
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        if (_hasActiveFilters)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_hasActiveFilters) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (filters.location?.trim().isNotEmpty == true)
                StatusBadge(label: filters.location!.trim(), variant: BadgeVariant.info),
              if (filters.contract?.trim().isNotEmpty == true)
                StatusBadge.contract(filters.contract!.trim()),
              if (filters.minSalary?.trim().isNotEmpty == true)
                StatusBadge(label: 'Min \$${filters.minSalary!.trim()}', variant: BadgeVariant.neutral),
              if (filters.maxSalary?.trim().isNotEmpty == true)
                StatusBadge(label: 'Max \$${filters.maxSalary!.trim()}', variant: BadgeVariant.neutral),
            ],
          ),
        ],
      ],
    );
  }
}

class _FiltersSheet extends StatefulWidget {
  final JobFilterParams initialFilters;

  const _FiltersSheet({required this.initialFilters});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late final TextEditingController _locationController;
  late final TextEditingController _minSalaryController;
  late final TextEditingController _maxSalaryController;
  late String _contract;

  @override
  void initState() {
    super.initState();
    _locationController =
        TextEditingController(text: widget.initialFilters.location ?? '');
    _minSalaryController =
        TextEditingController(text: widget.initialFilters.minSalary ?? '');
    _maxSalaryController =
        TextEditingController(text: widget.initialFilters.maxSalary ?? '');
    _contract = widget.initialFilters.contract ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Jobs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location'),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _contract.isEmpty ? null : _contract,
            items: const [
              DropdownMenuItem(value: 'full-time', child: Text('Full time')),
              DropdownMenuItem(value: 'part-time', child: Text('Part time')),
              DropdownMenuItem(value: 'contract', child: Text('Contract')),
            ],
            onChanged: (value) => setState(() => _contract = value ?? ''),
            decoration: const InputDecoration(labelText: 'Contract Type'),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Min Salary'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _maxSalaryController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Max Salary'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(const JobFilterParams()),
                child: const Text('Reset'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    widget.initialFilters.copyWith(
                      location: _locationController.text.trim(),
                      contract: _contract,
                      minSalary: _minSalaryController.text.trim(),
                      maxSalary: _maxSalaryController.text.trim(),
                    ),
                  );
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobActions extends StatelessWidget {
  final JobEntity job;

  const _JobActions({required this.job});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'edit') {
          await context.push(AppRouter.postJobPage, extra: job);
          if (context.mounted) {
            context.read<ManageJobsCubit>().loadMyJobs();
          }
          return;
        }

        final actionCubit = context.read<ManageJobActionCubit>();
        final success = value == 'delete'
            ? await actionCubit.deleteJob(job.id)
            : await actionCubit.archiveJob(job.id, !job.isArchived);

        if (!context.mounted) return;
        if (!success) {
          final state = actionCubit.state;
          final message = state is ErrorState<JobEntity?>
              ? state.message
              : 'Action failed, please try again';
          AppSnackBars.showError(context, message);
          return;
        }

        AppSnackBars.showSuccess(
          context,
          value == 'delete'
              ? 'Job deleted successfully'
              : job.isArchived
                  ? 'Job restored successfully'
                  : 'Job archived successfully',
        );
        context.read<ManageJobsCubit>().loadMyJobs();
      },
      itemBuilder: (_) => [
        const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
        PopupMenuItem<String>(
          value: 'archive',
          child: Text(job.isArchived ? 'Restore' : 'Archive'),
        ),
        const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
      ],
      child: const Icon(Icons.more_horiz_rounded),
    );
  }
}
