import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class AppTypography {
  static TextStyle get displayLg =>
      GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.2, height: 1.05);
  static TextStyle get displayMd =>
      GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8, height: 1.1);
  static TextStyle get headingLg =>
      GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.4, height: 1.2);
  static TextStyle get headingMd =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.2, height: 1.25);
  static TextStyle get headingSm =>
      GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get bodyLg =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5);
  static TextStyle get bodyMd =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45);
  static TextStyle get bodySm =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get labelLg =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1);
  static TextStyle get labelMd =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2);
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      );
}
