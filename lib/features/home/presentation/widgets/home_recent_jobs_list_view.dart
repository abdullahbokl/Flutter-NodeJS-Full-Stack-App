import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/vertical_shimmer.dart';
import '../../../../core/config/app_router.dart';
import '../../../jobs/presentation/manager/jobs_provider.dart';
import 'home_job_vertical_card.dart';

class HomeRecentJobsListView extends StatelessWidget {
  const HomeRecentJobsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, jobsProvider, child) {
        if (jobsProvider.isLoading) {
          const VerticalShimmer();
        }
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: min(jobsProvider.jobs.length, 3),
          itemBuilder: (context, index) {
            return HomeJobVerticalCard(
              job: jobsProvider.jobs[index],
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.jobPage,
                  arguments: jobsProvider.jobs[index],
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
}
