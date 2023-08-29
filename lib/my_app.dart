import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_router.dart';
import 'core/utils/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Boklo JobHub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.light,
            iconTheme: const IconThemeData(color: AppColors.dark),
            primarySwatch: Colors.grey,
          ),
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.onBoarding,
        );
      },
    );
  }
}
