import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/base_state.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/job_entity.dart';
import 'support/jobs_list_slivers.dart';

class JobsListContent extends StatelessWidget {
  final BaseState<List<JobEntity>> state;
  final VoidCallback onRetry;
  final bool isMine;
  final Widget? header;
  final ScrollController? scrollController;
  final ValueListenable<bool>? isLoadingMoreListenable;

  const JobsListContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.isMine,
    this.header,
    this.scrollController,
    this.isLoadingMoreListenable,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRetry(),
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (header != null)
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.md),
              sliver: SliverToBoxAdapter(child: header),
            ),
          buildJobsListSliver(
            state: state,
            isMine: isMine,
            onRetry: onRetry,
            isLoadingMoreListenable: isLoadingMoreListenable,
          ),
        ],
      ),
    );
  }
}
