import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_avatar.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/common/widgets/bloc_state_widget.dart';
import '../../../../core/common/widgets/premium_ui.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_session.dart';
import '../../../applications/data/models/job_application_model.dart';
import '../../../applications/presentation/bloc/my_applications_cubit.dart';
import '../../../applications/presentation/widgets/application_status_chip.dart';

class MyApplicationsPage extends StatelessWidget {
  const MyApplicationsPage({super.key});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(
      AppSession.isCompany ? AppRouter.companyDashboardPage : AppRouter.homePage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      child: BlocBuilder<MyApplicationsCubit, BaseState<List<JobApplicationModel>>>(
        builder: (context, state) => BlocStateWidget<List<JobApplicationModel>>(
          state: state,
          emptyTitle: 'No applications yet',
          emptySubtitle: 'Start exploring roles and submit your first application.',
          emptyIcon: Icons.assignment_outlined,
          onRetry: () => context.read<MyApplicationsCubit>().loadApplications(),
          onSuccess: (applications) => RefreshIndicator(
            onRefresh: () async => context.read<MyApplicationsCubit>().loadApplications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: applications.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PageHeader(
                    eyebrow: 'Tracker',
                    title: 'Your applications',
                    subtitle: 'A clearer view from applied to decision.',
                    leadingAction: PageHeaderAction.icon(
                      onPressed: () => _handleBack(context),
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                    ),
                    actions: [
                      PageHeaderAction.text(
                        onPressed: () => context.push(AppRouter.chatPage),
                        label: 'Messages',
                      ),
                    ],
                  );
                }

                final app = applications[index - 1];
                return AppCard(
                  onTap: () => context.push('${AppRouter.jobsListPage}/${app.job.id}', extra: app.job),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppAvatar(radius: 22, fallbackInitials: app.job.company, imageUrl: app.job.imageUrl),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app.job.title, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text('${app.job.company} • ${app.job.location}',
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          ApplicationStatusChip(status: app.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ApplicationStatusStepper(status: app.status),
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
