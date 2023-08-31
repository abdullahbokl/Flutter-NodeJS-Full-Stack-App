import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/app_style.dart';
import '../../../../core/common/widgets/custom_search_widget.dart';
import '../../../../core/common/widgets/heading_widget.dart';
import '../../../../core/common/widgets/height_spacer.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/utils/app_colors.dart';
import 'home_popular_jobs_list_view.dart';
import 'home_recent_jobs_list_view.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeightSpacer(size: 10),
              Text('Search\nFind & Apply',
                  style: appStyle(40, AppColors.dark, FontWeight.bold)),
              const HeightSpacer(size: 40),
              CustomSearchWidget(
                onTap: () => Navigator.pushNamed(context, AppRouter.search),
              ),
              const HeightSpacer(size: 30),
              HeadingWidget(
                text: 'Popular Jobs',
                onTap: () {},
              ),
              const HeightSpacer(size: 15),
              const HomePopularJobsListView(),
              const HeightSpacer(size: 20),
              HeadingWidget(
                text: 'Recent Jobs',
                onTap: () {},
              ),
              const HeightSpacer(size: 20),
              const HomeRecentJobsListView(),
              const HeightSpacer(size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
