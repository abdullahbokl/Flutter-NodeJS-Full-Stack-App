import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core neutrals
  static const dark = Color(0xFF0C1720);
  static const light = Color(0xFFFFFFFF);
  static const lightGrey = Color(0xFFF4F7F8);
  static const darkGrey = Color(0xFF667085);
  static const darkBlue = Color(0xFF0F2231);

  // Brand palette
  static const teal = Color(0xFF0D9488);
  static const tealDeep = Color(0xFF0A6C68);
  static const gold = Color(0xFFE7B75F);
  static const goldSoft = Color(0xFFF6DDA5);
  static const sky = Color(0xFFB6DCE8);
  static const navy = Color(0xFF163047);

  // Legacy aliases kept for compatibility
  static const lightGreen = gold;
  static const lightBlue = teal;
  static const lightPurple = goldSoft;
  static const darkPurple = tealDeep;

  // Semantic aliases — light
  static const primary = teal;
  static const primaryDark = tealDeep;
  static const accent = gold;
  static const accentSoft = goldSoft;
  static const error = Color(0xFFD64545);
  static const success = Color(0xFF2F9E73);
  static const warning = Color(0xFFCC8B2F);
  static const info = Color(0xFF3C8DB5);

  static const surface = Color(0xFFF9FBFB);
  static const surfaceVariant = Color(0xFFF0F5F5);
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const backgroundLight = light;
  static const glassStroke = Color(0x66FFFFFF);
  static const cardBorder = Color(0x1A0C1720);
  static const shadow = Color(0x140E2333);

  static const textPrimary = Color(0xFF10212E);
  static const textSecondary = Color(0xFF718096);
  static const textHint = Color(0xFF97A6B2);
  static const divider = Color(0xFFE3EAEC);

  // Semantic aliases — dark
  static const surfaceDark = Color(0xFF132430);
  static const surfaceVariantDark = Color(0xFF1B3443);
  static const backgroundDark = darkBlue;
  static const cardBorderDark = Color(0x1FFFFFFF);

  static const textPrimaryDark = Color(0xFFF5F8FA);
  static const textSecondaryDark = Color(0xFFA0AEC0);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F7C78), Color(0xFF194868)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE7B75F), Color(0xFFF4D89A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pageGlow = LinearGradient(
    colors: [Color(0xFFF5FBFA), Color(0xFFFFFFFF), Color(0xFFF7FAFB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
