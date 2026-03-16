import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../../core/common/base_state.dart';
import '../../../../domain/entities/job_filter_params.dart';
import '../../../../domain/entities/job_entity.dart';
import '../../../bloc/jobs_cubit.dart';

class BrowseJobsController {
  final JobsCubit jobsCubit;
  late final TextEditingController queryController;
  late final FocusNode focusNode;
  late final ScrollController scrollController;
  late final ValueNotifier<bool> isLoadingMoreNotifier;
  Timer? initialLoadTimer;

  BrowseJobsController(this.jobsCubit) {
    final filters = jobsCubit.filters;
    queryController = TextEditingController(text: filters.query);
    focusNode = FocusNode();
    isLoadingMoreNotifier = ValueNotifier<bool>(jobsCubit.isLoadingMore);
    scrollController = ScrollController()..addListener(_handleScroll);
  }

  void scheduleInitialLoad(VoidCallback loadIfNeeded) {
    initialLoadTimer = Timer(const Duration(milliseconds: 120), loadIfNeeded);
  }

  Future<void> applyFilters(JobFilterParams filters) {
    return jobsCubit.applyFilters(
      filters.copyWith(query: queryController.text.trim()),
    );
  }

  Future<void> clearFilters() async {
    queryController.clear();
    await jobsCubit.clearFilters();
  }

  void reset() {
    focusNode.unfocus();
    queryController.clear();
    jobsCubit.reset();
  }

  void dispose() {
    initialLoadTimer?.cancel();
    reset();
    scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    isLoadingMoreNotifier.dispose();
    queryController.dispose();
    focusNode.dispose();
  }

  void _handleScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent - 240 ||
        jobsCubit.isLoadingMore ||
        !jobsCubit.hasMore) {
      return;
    }

    isLoadingMoreNotifier.value = true;
    jobsCubit.loadMore().whenComplete(() {
      isLoadingMoreNotifier.value = false;
    });
  }

  bool shouldLoadInitially() {
    return jobsCubit.state is InitialState<List<JobEntity>>;
  }
}
