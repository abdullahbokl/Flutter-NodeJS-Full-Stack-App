import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/reusable_text.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/assets.dart';
import '../manager/search_provider.dart';
import '../widgets/custom_field.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.orange,
        iconTheme: const IconThemeData(color: AppColors.light),
        title: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            return CustomField(
              hintText: 'Search for jobs',
              controller: searchProvider.searchController,
              suffixIcon: GestureDetector(
                onTap: () {},
                child: const Icon(AntDesign.search1),
              ),
            );
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.imagesOptimizedSearch),
            ReusableText(
              text: 'Start searching for jobs',
              style: appStyle(24, AppColors.dark, FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
