import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/common/managers/drawer_provider.dart';
import 'core/common/managers/image_handler_provider.dart';
import 'core/config/app_setup.dart';
import 'features/bookmarks/presentation/manager/bookmark_provider.dart';
import 'features/home/presentation/manager/home_provider.dart';
import 'features/jobs/presentation/manager/jobs_provider.dart';
import 'features/profile/presentation/manager/edit_profile_provider.dart';
import 'features/profile/presentation/manager/profile_provider.dart';
import 'features/search/presentation/manager/search_provider.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSetup.setupServiceLocator();
  await AppSetup.loadData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DrawerProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => EditProfileProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => JobsProvider()),
        ChangeNotifierProvider(create: (context) => BookMarkNotifier()),
        ChangeNotifierProvider(create: (context) => ImageHandlerProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
