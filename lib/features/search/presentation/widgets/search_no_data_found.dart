import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/assets.dart';
import '../manager/search_provider.dart';

class SearchNoDataFound extends StatelessWidget {
  const SearchNoDataFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(Assets.imagesOptimizedSearch),
        Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            return ReusableText(
              text: searchProvider.searchController.text.isEmpty
                  ? 'Start searching for jobs'
                  : 'No jobs found',
              style: appStyle(24, AppColors.dark, FontWeight.bold),
            );
          },
        ),
      ],
    );
  }
}
