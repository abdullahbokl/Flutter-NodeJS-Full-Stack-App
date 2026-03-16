import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/base_state.dart';
import '../../../../../core/navigation/app_navigation.dart';
import '../../../domain/entities/job_filter_params.dart';
import '../../../domain/entities/job_entity.dart';
import '../../bloc/jobs_cubit.dart';
import '../../widgets/jobs_list/jobs_browse_header.dart';
import '../../widgets/jobs_list/jobs_filters_sheet.dart';
import 'jobs_list_content.dart';
import 'support/browse_jobs_controller.dart';

class BrowseJobsView extends StatefulWidget {
  final String title;
  final bool autofocusSearch;

  const BrowseJobsView({
    super.key,
    required this.title,
    required this.autofocusSearch,
  });

  @override
  State<BrowseJobsView> createState() => _BrowseJobsViewState();
}

class _BrowseJobsViewState extends State<BrowseJobsView> {
  late final BrowseJobsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BrowseJobsController(context.read<JobsCubit>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.scheduleInitialLoad(() {
        if (!mounted || !_controller.shouldLoadInitially()) {
          return;
        }
        _controller.jobsCubit.loadJobs(const JobFilterParams());
      });
    });
  }

  Future<void> _openFilters() async {
    final filters = await showModalBottomSheet<JobFilterParams>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          JobsFiltersSheet(initialFilters: _controller.jobsCubit.filters),
    );
    if (filters == null || !mounted) {
      return;
    }
    await _controller.applyFilters(filters);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobsCubit, BaseState<List<JobEntity>>>(
      builder: (context, state) {
        final filters = context.read<JobsCubit>().filters;
        return JobsListContent(
          state: state,
          onRetry: () => context.read<JobsCubit>().retry(),
          isMine: false,
          scrollController: _controller.scrollController,
          isLoadingMoreListenable: _controller.isLoadingMoreNotifier,
          header: JobsBrowseHeader(
            title: widget.title,
            controller: _controller.queryController,
            focusNode: _controller.focusNode,
            autofocusSearch: widget.autofocusSearch,
            filters: filters,
            onChanged: (query) => context.read<JobsCubit>().search(query),
            onClear: _controller.clearFilters,
            onFilterTap: _openFilters,
            onBack: () {
              _controller.reset();
              AppNavigation.popOrGoHome(context);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
