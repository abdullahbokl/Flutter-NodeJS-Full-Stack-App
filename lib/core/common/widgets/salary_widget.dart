import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import 'app_style.dart';
import 'reusable_text.dart';

class SalaryModel {
  final String amount;
  final String salaryType;

  SalaryModel({
    required this.amount,
    required this.salaryType,
  });
}

class SalaryType {
  static const String perMonth = 'Month';
  static const String perWeek = 'Week';
  static const String perHour = 'Hour';
}

class SalaryWidget extends StatelessWidget {
  const SalaryWidget({
    super.key,
    required this.salary,
  });

  final SalaryModel salary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReusableText(
          text: '${salary.amount}K',
          style: appStyle(23, AppColors.dark, FontWeight.w600),
        ),
        ReusableText(
          text: '/${salary.salaryType}',
          style: appStyle(23, AppColors.darkGrey, FontWeight.w600),
        ),
      ],
    );
  }
}
