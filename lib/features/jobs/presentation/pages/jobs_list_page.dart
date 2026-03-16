import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../domain/entities/job_entity.dart';
import '../bloc/manage_jobs_cubit.dart';
import 'jobs_list/browse_jobs_view.dart';
import 'jobs_list/jobs_list_content.dart';

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
              builder: (context, state) => JobsListContent(
                state: state,
                onRetry: () => context.read<ManageJobsCubit>().loadMyJobs(),
                isMine: true,
              ),
            )
          : BrowseJobsView(
              title: title ?? 'All Jobs',
              autofocusSearch: autofocusSearch,
            ),
    );
  }
}
