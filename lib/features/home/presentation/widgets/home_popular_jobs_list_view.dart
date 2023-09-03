import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/horizontal_list_shimmer.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../jobs/presentation/manager/jobs_provider.dart';
import 'home_job_horizontal_card.dart';

class HomePopularJobsListView extends StatelessWidget {
  const HomePopularJobsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.height * 0.25,
      child: Consumer<JobsProvider>(
        builder: (context, jobsProvider, child) {
          if (jobsProvider.isLoading) {
            return const HorizontalListShimmer();
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jobsProvider.jobs.length,
            itemBuilder: (context, index) => HomeJobHorizontalCard(
              job: jobsProvider.jobs[index],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.jobDetailsPage,
                  arguments: jobsProvider.jobs[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
