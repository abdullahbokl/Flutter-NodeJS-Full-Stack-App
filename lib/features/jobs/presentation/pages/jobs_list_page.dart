import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_back_button.dart';
import '../../../../core/common/widgets/vertical_list_shimmer.dart';
import '../../../../core/config/app_router.dart';
import '../../../home/presentation/widgets/home_job_vertical_card.dart';
import '../manager/jobs_provider.dart';

class JobsListPage extends StatelessWidget {
  const JobsListPage({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: const CustomBackButton(),
        title: title ?? 'Jobs',
      ),
      body: Consumer<JobsProvider>(
        builder: (context, jobsProvider, child) {
          return jobsProvider.isLoading
              ? const VerticalListShimmer()
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: jobsProvider.jobs.length,
                  itemBuilder: (context, index) {
                    return HomeJobVerticalCard(
                      job: jobsProvider.jobs[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.jobDetailsPage,
                          arguments: jobsProvider.jobs[index],
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
        },
      ),
    );
  }
}
