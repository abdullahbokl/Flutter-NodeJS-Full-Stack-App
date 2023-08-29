import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_btn.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../chat/presentation/manager/chat_provider.dart';
import 'job_requirements_list_view.dart';
import 'job_summary_card.dart';

class JobDetailsBody extends StatelessWidget {
  const JobDetailsBody({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
              onTap: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.noHeader,
                  animType: AnimType.bottomSlide,
                  title: 'Apply Now',
                  btnCancelOnPress: () {},
                  // rounded green button
                  btnOk: GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        await chatProvider.createChat(receiverId: job.agentId);
                        chatProvider.sendMessage(receiverId: job.agentId);
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
                  // btnOkOnPress: () {
                  //   if (formKey.currentState!.validate()) {
                  //     chatProvider.sendMessage(receiverId: job.agentId);
                  //     Navigator.pop(context);
                  //   }
                  // },
                  // add a text form field to send a message
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
                            controller: chatProvider.messageController,
                            decoration: InputDecoration(
                              hintText: 'Write a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
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
              },
              text: 'Apply Now',
              color: AppColors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }
}
