import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jobhub_flutter/features/search/presentation/widgets/search_no_data_found.dart';
import 'package:jobhub_flutter/features/search/presentation/widgets/search_result_list.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/vertical_list_shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../manager/search_provider.dart';
import '../widgets/custom_search_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        iconTheme: const IconThemeData(color: AppColors.light),
        title: const CustomSearchField(),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.h),
        child: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            if (searchProvider.isLoading) {
              return const VerticalListShimmer();
            } else if (searchProvider.jobs.isNotEmpty) {
              return const SearchResultList();
            } else {
              return const SearchNoDataFound();
            }
          },
        ),
      ),
    );
  }
}
