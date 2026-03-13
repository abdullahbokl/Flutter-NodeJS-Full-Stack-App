import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../applications/data/models/job_application_model.dart';
import '../../../applications/presentation/bloc/my_applications_cubit.dart';
import '../../../applications/presentation/widgets/application_status_chip.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () => context.push(AppRouter.chatPage),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<MyApplicationsCubit>().loadApplications(),
          ),
        ],
      ),
      body: BlocBuilder<MyApplicationsCubit, BaseState<List<JobApplicationModel>>>(
        builder: (context, state) => BlocStateWidget<List<JobApplicationModel>>(
          state: state,
          emptyTitle: 'No applied jobs yet',
          emptySubtitle: 'Start exploring roles and submit your first application',
          emptyIcon: Icons.work_outline_rounded,
          onRetry: () => context.read<MyApplicationsCubit>().loadApplications(),
          onSuccess: (applications) => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final app = applications[i];
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                        title: Text(
                          app.job.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${app.job.company} • ${app.job.location}',
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              ApplicationStatusChip(status: app.status),
                            ],
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          context.push('${AppRouter.jobsListPage}/${app.job.id}', extra: app.job);
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
