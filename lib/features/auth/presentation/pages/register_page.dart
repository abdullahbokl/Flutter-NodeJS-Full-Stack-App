import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../widgets/register/register_page_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Register',
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: const RegisterPageBody(),
    );
  }
}
