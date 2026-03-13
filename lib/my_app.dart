import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/common/bloc/theme_cubit.dart';
import 'core/common/widgets/connectivity_wrapper.dart';
import 'core/config/app_router.dart';
import 'core/config/app_setup.dart';
import 'core/theme/app_theme.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';
import 'features/home/presentation/bloc/home_cubit.dart';
import 'features/jobs/presentation/bloc/jobs_cubit.dart';
import 'features/bookmarks/presentation/bloc/bookmarks_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()..loadProfile()),
        BlocProvider(create: (_) => getIt<HomeCubit>()..loadJobs()),
        BlocProvider(create: (_) => getIt<JobsCubit>()..loadJobs()),
        BlocProvider(create: (_) => getIt<BookmarksCubit>()..loadBookmarks()),
      ],
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
