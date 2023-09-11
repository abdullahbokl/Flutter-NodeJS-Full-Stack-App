import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/drawer/drawer_icon.dart';
import '../manager/profile_provider.dart';
import '../widgets/profile/profile_page_body.dart';

//
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<ProfileProvider>(context, listen: false).getUserProfile();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        leading: Padding(
          padding: EdgeInsets.all(12.h),
          child: const DrawerIcon(),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ProfilePageBody(),
      ),
    );
  }
}
