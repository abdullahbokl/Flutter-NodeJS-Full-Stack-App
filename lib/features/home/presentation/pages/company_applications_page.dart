import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../applications/data/models/job_application_model.dart';
import '../../../applications/domain/entities/application_status.dart';
import '../../../applications/presentation/bloc/application_action_cubit.dart';
import '../../../applications/presentation/bloc/received_applications_cubit.dart';
import '../../../applications/presentation/widgets/application_status_chip.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';

class CompanyApplicationsPage extends StatefulWidget {
  const CompanyApplicationsPage({super.key});

  @override
  State<CompanyApplicationsPage> createState() => _CompanyApplicationsPageState();
}

class _CompanyApplicationsPageState extends State<CompanyApplicationsPage> {
  Future<void> _messageApplicant(JobApplicationModel app) async {
    final chatCubit = getIt<ChatCubit>();
    final chat = await chatCubit.createOrGetChat(
      app.applicant?.id ?? '',
      jobId: app.job.id,
    );
    await chatCubit.close();

    if (!mounted) return;

    if (chat == null) {
      AppSnackBars.showError(context, 'Failed to open chat with applicant');
      return;
    }

    context.push('/chat/${chat.id}', extra: chat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<ReceivedApplicationsCubit>().loadApplications(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<ReceivedApplicationsCubit, BaseState<List<JobApplicationModel>>>(
        builder: (context, state) => BlocStateWidget<List<JobApplicationModel>>(
          state: state,
          emptyTitle: 'No applications yet',
          emptySubtitle: 'New candidates will appear here',
          emptyIcon: Icons.inbox_outlined,
          onRetry: () => context.read<ReceivedApplicationsCubit>().loadApplications(),
          onSuccess: (applications) => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final app = applications[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    app.job.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ApplicationStatusChip(status: app.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Applicant: ${app.applicant?.displayName ?? 'Applicant'}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Job: ${app.job.company} • ${app.job.location}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (app.coverLetter.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                app.coverLetter,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.sm),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Wrap(
                                spacing: AppSpacing.sm,
                                runSpacing: AppSpacing.sm,
                                alignment: WrapAlignment.end,
                                children: [
                                  _StatusMenu(
                                    application: app,
                                    onUpdated: () => context
                                        .read<ReceivedApplicationsCubit>()
                                        .loadApplications(),
                                  ),
                                  OutlinedButton.icon(
                                    onPressed: () => _messageApplicant(app),
                                    icon: const Icon(Icons.chat_bubble_outline),
                                    label: const Text('Message'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _StatusMenu extends StatefulWidget {
  final JobApplicationModel application;
  final VoidCallback onUpdated;

  const _StatusMenu({
    required this.application,
    required this.onUpdated,
  });

  @override
  State<_StatusMenu> createState() => _StatusMenuState();
}

class _StatusMenuState extends State<_StatusMenu> {
  bool _updating = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: !_updating,
      onSelected: (status) async {
        setState(() => _updating = true);
        final actionCubit = context.read<ApplicationActionCubit>();
        final updated = await actionCubit.updateStatus(
          applicationId: widget.application.id,
          status: status,
        );
        if (!context.mounted) return;
        setState(() => _updating = false);
        if (updated == null) {
          final state = actionCubit.state;
          final message = state is ErrorState<JobApplicationModel>
              ? state.message
              : 'Failed to update status';
          AppSnackBars.showError(context, message);
          return;
        }
        AppSnackBars.showSuccess(context, 'Application status updated');
        widget.onUpdated();
      },
      itemBuilder: (_) => ApplicationStatus.flow
          .map(
            (status) => PopupMenuItem<String>(
              value: status,
              child: Text(ApplicationStatus.label(status)),
            ),
          )
          .toList(),
      child: OutlinedButton.icon(
        onPressed: null,
        icon: _updating
            ? const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.swap_horiz_rounded),
        label: const Text('Update Status'),
      ),
    );
  }
}
