import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/config/app_router.dart';
import '../../../home/presentation/widgets/home_job_vertical_card.dart';
import '../manager/search_provider.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: searchProvider.jobs.length,
      itemBuilder: (context, index) {
        return HomeJobVerticalCard(
          job: searchProvider.jobs[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouter.jobDetailsPage,
              arguments: searchProvider.jobs[index],
            );
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
