import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/drawer/drawer_icon.dart';
import '../../../../core/common/widgets/user_avatar_image.dart';
import '../manager/home_provider.dart';
import '../widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeProvider>(context, listen: false).loadData(context);
    return Scaffold(
      appBar: customAppBar(
        leading: Padding(
          padding: EdgeInsets.all(12.h),
          child: const DrawerIcon(),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(12.h),
            child: const UserAvatarImage(),
          ),
        ],
      ),
      body: const HomePageBody(),
    );
  }
}
