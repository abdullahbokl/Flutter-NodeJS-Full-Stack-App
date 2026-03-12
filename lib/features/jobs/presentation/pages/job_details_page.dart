import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/models/job_model.dart';
import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_loader.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_snackbars.dart';
import '../manager/job_details_provider.dart';
import '../widgets/job_details_body.dart';

class JobDetailsPage extends StatelessWidget {
  final JobModel job;
  const JobDetailsPage({super.key, required this.job});

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
            builder: (context, provider, _) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => provider.changeBookmarkStatus(
                  id: job.id,
                  context: context,
                ),
                child: provider.isLoading
                    ? CustomLoader(color: AppColors.dark, size: 20.r)
                    : provider.getBookmarkIcon(),
              ),
            ),
          ),
        ],
      ),
      body: JobDetailsBody(job: job),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 40, child: VerticalDivider(width: 1, color: AppColors.divider));
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      );
}
