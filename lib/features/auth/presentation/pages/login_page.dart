import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../manager/login/login_provider.dart';
import '../widgets/login/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginProvider(),
      child: const Scaffold(
        body: LoginPageBody(),
      ),
    );
  }
}
