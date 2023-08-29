import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/common/widgets/height_spacer.dart';
import 'register_form.dart';
import 'register_greeting_messages.dart';
import 'register_login_button.dart';

class RegisterPageBody extends StatelessWidget {
  const RegisterPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        children: const [
          HeightSpacer(size: 50),
          RegisterGreetingMessages(),
          HeightSpacer(size: 50),
          RegisterForm(),
          HeightSpacer(size: 20),
          RegisterLoginButton(),
        ],
      ),
    );
  }
}
