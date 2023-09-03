import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_bar.dart';
import '../../../../core/common/widgets/custom_back_button.dart';
import '../widgets/register/register_page_body.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: 'Register',
        leading: const CustomBackButton(),
      ),
      body: const RegisterPageBody(),
    );
  }
}
