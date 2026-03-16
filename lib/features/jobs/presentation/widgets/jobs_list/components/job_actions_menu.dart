import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/common/base_state.dart';
import '../../../../../../core/config/app_router.dart';
import '../../../../../../core/utils/app_snackbars.dart';
import '../../../../domain/entities/job_entity.dart';
import '../../../bloc/manage_job_action_cubit.dart';
import '../../../bloc/manage_jobs_cubit.dart';

class JobActionsMenu extends StatelessWidget {
  final JobEntity job;

  const JobActionsMenu({
    super.key,
    required this.job,
  });

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

        if (!context.mounted) {
          return;
        }
        if (!success) {
          final state = actionCubit.state;
          final message = state is ErrorState<JobEntity?>
              ? state.message
              : 'Action failed, please try again';
          AppSnackBars.showError(context, message);
          return;
        }

        AppSnackBars.showSuccess(context, _successMessage(value));
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

  String _successMessage(String value) {
    if (value == 'delete') {
      return 'Job deleted successfully';
    }
    return job.isArchived
        ? 'Job restored successfully'
        : 'Job archived successfully';
  }
}
