import 'package:flutter/material.dart';

import 'core/config/app_setup.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSetup.setupServiceLocator();
  await AppSetup.loadData();
  runApp(const MyApp());
}


