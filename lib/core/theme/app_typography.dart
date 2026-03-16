import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AppTypography {
  static const TextStyle displayLg = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.05,
  );
  static const TextStyle displayMd = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.1,
  );
  static const TextStyle headingLg = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.2,
  );
  static const TextStyle headingMd = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.25,
  );
  static const TextStyle headingSm = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );
  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );
  static const TextStyle labelLg = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
  static const TextStyle labelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );
}
