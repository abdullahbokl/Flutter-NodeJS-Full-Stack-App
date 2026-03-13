import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/base_state.dart';
import '../../domain/entities/job_entity.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_session.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../../../applications/presentation/bloc/application_action_cubit.dart';
import '../../../chat/presentation/bloc/chat_cubit.dart';
import 'job_requirements_list_view.dart';
import 'job_summary_card.dart';

class JobDetailsBody extends StatelessWidget {
  const JobDetailsBody({
    super.key,
    required this.job,
  });

  final JobEntity job;

  @override
  Widget build(BuildContext context) {
    final isPublisher =
        AppSession.userId.isNotEmpty && job.agentId == AppSession.userId;

    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const HeightSpacer(size: 30),
              // summary
              JobSummaryCard(job: job),
              const HeightSpacer(size: 20),
              // job description
              ReusableText(
                text: 'Job description',
                style: appStyle(22, AppColors.dark, FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              Text(
                job.description,
                textAlign: TextAlign.justify,
                maxLines: 8,
                style: appStyle(16, AppColors.darkGrey, FontWeight.normal),
              ),
              const HeightSpacer(size: 20),
              // job requirements
              ReusableText(
                text: 'Job requirements',
                style: appStyle(22, AppColors.dark, FontWeight.w600),
              ),
              const HeightSpacer(size: 10),
              JobRequirementsListView(requirements: job.requirements),
              const HeightSpacer(size: 50),
            ],
          ),
          // apply now button
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              onTap: () => isPublisher
                  ? AppSnackBars.showInfo(context, 'Edit job flow coming soon')
                  : _showApplyDialog(context),
              text: isPublisher ? 'Edit Job' : 'Apply Now',
              color: AppColors.lightGreen,
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
      title: 'Apply Now',
      btnCancelOnPress: () {},
      btnOk: GestureDetector(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            final coverLetter = messageController.text.trim();
            final chatCubit = context.read<ChatCubit>();
            final applicationCubit = context.read<ApplicationActionCubit>();
            try {
              final application = await applicationCubit.applyForJob(
                jobId: job.id,
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
              job.agentId,
              jobId: job.id,
            );
            if (!context.mounted) return;
            if (chat != null) {
              AppSnackBars.showSuccess(context, 'Application sent!');
            } else {
              // Application is already submitted even if chat creation fails.
              AppSnackBars.showInfo(context, 'Application sent, but chat was not created');
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          }
        },
        child: Container(
          width: 100.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: ReusableText(
            text: 'Apply',
            style: appStyle(16, Colors.white, FontWeight.w600),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                'Send a message to the agent',
                style: appStyle(
                  14,
                  AppColors.dark,
                  FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Write a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    ).show();
  }
}
