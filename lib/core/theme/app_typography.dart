import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_colors.dart';

class AppTypography {
  static TextStyle get displayLg => GoogleFonts.inter(
        fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static TextStyle get displayMd => GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.3);
  static TextStyle get headingLg => GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w700);
  static TextStyle get headingMd => GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get headingSm => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle get bodyLg => GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400);
  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary);
}

