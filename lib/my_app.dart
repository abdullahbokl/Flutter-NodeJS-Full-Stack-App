import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/common/bloc/theme_cubit.dart';
import 'core/common/widgets/connectivity_wrapper.dart';
import 'core/config/app_router.dart';
import 'core/config/app_setup.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(getIt<SharedPreferences>()),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            useInheritedMediaQuery: true,
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, _) {
              return ConnectivityWrapper(
                child: MaterialApp.router(
                  title: 'JobHub',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: themeMode,
                  routerConfig: appRouter,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
