import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/widgets/height_spacer.dart';
import 'login_form.dart';
import 'login_greeting_messages.dart';
import 'login_register_button.dart';

class LoginPageBody extends StatelessWidget {
  const LoginPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          shrinkWrap: true,
          children: const [
            LoginGreetingMessages(),
            HeightSpacer(size: 50),
            LoginForm(),
            HeightSpacer(size: 20),
            LoginRegisterButton(),
          ],
        ),
      ),
    );
  }
}
