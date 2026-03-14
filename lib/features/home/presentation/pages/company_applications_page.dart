import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/common/widgets/status_badge.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_session.dart';
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
  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(
      AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage,
    );
  }

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
    return PremiumScaffold(
      child: BlocBuilder<ReceivedApplicationsCubit, BaseState<List<JobApplicationModel>>>(
        builder: (context, state) => BlocStateWidget<List<JobApplicationModel>>(
          state: state,
          emptyTitle: 'No applications yet',
          emptySubtitle: 'New candidates will appear here once people start applying.',
          emptyIcon: Icons.groups_outlined,
          onRetry: () => context.read<ReceivedApplicationsCubit>().loadApplications(),
          onSuccess: (applications) => RefreshIndicator(
            onRefresh: () async => context.read<ReceivedApplicationsCubit>().loadApplications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: applications.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PageHeader(
                    title: 'Applicant pipeline',
                    subtitle: 'Screen candidates, update status, and jump into conversations.',
                    leadingAction: PageHeaderAction.icon(
                      onPressed: () => _handleBack(context),
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                    ),
                    actions: [
                      PageHeaderAction.icon(
                        onPressed: () =>
                            context.read<ReceivedApplicationsCubit>().loadApplications(),
                        icon: Icons.refresh_rounded,
                        tooltip: 'Refresh',
                      ),
                    ],
                  );
                }

                final app = applications[index - 1];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppAvatar(
                            radius: 22,
                            fallbackInitials: app.applicant?.fullName ?? app.applicant?.userName ?? 'A',
                            imageUrl: app.applicant?.profilePic.lastOrNull,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app.applicant?.fullName ?? app.applicant?.userName ?? 'Applicant',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(app.job.title, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          ApplicationStatusChip(status: app.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          StatusBadge(label: app.job.company, variant: BadgeVariant.info),
                          StatusBadge(label: app.job.location, variant: BadgeVariant.neutral),
                          if (app.applicant?.skills.isNotEmpty == true)
                            StatusBadge(label: app.applicant!.skills.first, variant: BadgeVariant.success),
                        ],
                      ),
                      if (app.coverLetter.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          app.coverLetter,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _StatusMenu(
                              application: app,
                              onUpdated: () => context.read<ReceivedApplicationsCubit>().loadApplications(),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppButton(
                              label: 'Message',
                              variant: AppButtonVariant.outline,
                              icon: Icons.chat_bubble_outline_rounded,
                              onTap: () => _messageApplicant(app),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
      child: IgnorePointer(
        child: AppButton(
          label: _updating ? 'Updating...' : 'Update Status',
          variant: AppButtonVariant.soft,
          icon: Icons.swap_horiz_rounded,
          onTap: () {},
        ),
      ),
    );
  }
}
