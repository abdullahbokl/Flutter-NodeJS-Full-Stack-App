import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_loader.dart';
import '../../../../core/utils/app_colors.dart';
import '../manager/job_details_provider.dart';
import '../widgets/job_details_body.dart';

class JobDetailsPage extends StatelessWidget {
  const JobDetailsPage({
    super.key,
    required this.job,
  });

  final JobModel job;

  @override
  Widget build(BuildContext context) {
    Provider.of<JobDetailsProvider>(context, listen: false)
        .checkIfJobIsBookmarked(job.id);
    return Scaffold(
      appBar: customAppBar(
        leading: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.arrow_left),
        ),
        title: job.title,
        actions: [
          Consumer<JobDetailsProvider>(
            builder: (context, jobDetailsProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => jobDetailsProvider.changeBookmarkStatus(
                    id: job.id,
                    context: context,
                  ),
                  child: jobDetailsProvider.isLoading
                      ? CustomLoader(color: AppColors.dark, size: 20.r)
                      : jobDetailsProvider.getBookmarkIcon(),
                ),
              );
            },
          ),
        ],
      ),
      body: JobDetailsBody(job: job),
    );
  }
}
