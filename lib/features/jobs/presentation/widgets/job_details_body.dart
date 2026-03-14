import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/base_state.dart';
import '../../../../core/common/widgets/app_button.dart';
import '../../../../core/common/widgets/app_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../applications/presentation/bloc/application_action_cubit.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';
import '../../domain/entities/job_entity.dart';

class JobDetailsBody extends StatefulWidget {
  final JobEntity job;

  const JobDetailsBody({
    super.key,
    required this.job,
  });

  @override
  State<JobDetailsBody> createState() => JobDetailsBodyState();
}

class JobDetailsBodyState extends State<JobDetailsBody> {
  bool get _isPublisher =>
      AppSession.userId.isNotEmpty && widget.job.agentId == AppSession.userId;

  Future<void> handlePrimaryAction() async {
    if (_isPublisher) {
      AppSnackBars.showInfo(context, 'Edit job flow coming soon');
      return;
    }
    _showApplyDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Salary', style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 4),
                      Text('\$${widget.job.salary}', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule', style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 4),
                      Text(widget.job.period, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionCard(
            title: 'Job description',
            child: Text(
              widget.job.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Requirements',
            child: Column(
              children: widget.job.requirements
                  .map(
                    (requirement) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.check_circle_rounded, size: 18),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(requirement, style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SectionCard(
            title: 'Company snapshot',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MetaRow(label: 'Company', value: widget.job.company),
                _MetaRow(label: 'Location', value: widget.job.location),
                _MetaRow(label: 'Contract', value: widget.job.contract),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showApplyDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final messageController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.bottomSlide,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text('Apply with a short introduction', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your existing apply flow stays the same. We are only improving the presentation.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: const InputDecoration(hintText: 'Tell the employer why you are a good fit'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Send Application',
                onTap: () async {
                  if (formKey.currentState?.validate() != true) return;

                  final coverLetter = messageController.text.trim();
                  final chatCubit = context.read<ChatCubit>();
                  final applicationCubit = context.read<ApplicationActionCubit>();
                  try {
                    final application = await applicationCubit.applyForJob(
                      jobId: widget.job.id,
                      coverLetter: coverLetter,
                    );
                    if (application == null) {
                      if (!context.mounted) return;
                      final state = applicationCubit.state;
                      final message = switch (state) {
                        ErrorState<dynamic>(message: final errorMessage) => errorMessage,
                        _ => 'Failed to apply',
                      };
                      AppSnackBars.showError(context, message);
                      return;
                    }
                  } catch (_) {
                    if (!context.mounted) return;
                    AppSnackBars.showError(context, 'Failed to submit application');
                    return;
                  }

                  final chat = await chatCubit.createOrGetChat(
                    widget.job.agentId,
                    jobId: widget.job.id,
                  );
                  if (!context.mounted) return;
                  if (chat != null) {
                    AppSnackBars.showSuccess(context, 'Application sent!');
                  } else {
                    AppSnackBars.showInfo(context, 'Application sent, but chat was not created');
                  }
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    ).show();
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
