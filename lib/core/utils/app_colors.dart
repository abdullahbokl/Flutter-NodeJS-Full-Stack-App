import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand palette ─────────────────────────────────────────────────────────
  static const dark        = Color(0xFF000000);
  static const light       = Color(0xFFFFFFFF);
  static const lightGrey   = Color(0xFFF4EEEE);
  static const darkGrey    = Color(0xFF9B9B9B);
  static const lightGreen  = Color(0xFF9EB23B);
  static const lightBlue   = Color(0xFF3663E3);
  static const darkBlue    = Color(0xFF1C153E);
  static const lightPurple = Color(0xFF818CF8); // indigo-400
  static const darkPurple  = Color(0xFF4F46E5); // indigo-600

  // ── Semantic aliases — light ───────────────────────────────────────────────
  static const primary        = lightBlue;
  static const accent         = lightPurple;
  static const error          = Color(0xFFE53E3E);
  static const success        = Color(0xFF38A169);
  static const warning        = Color(0xFFDD6B20);
  static const info           = Color(0xFF3182CE);

  static const surface         = Color(0xFFF8F9FA);
  static const surfaceVariant  = Color(0xFFEDF2F7);
  static const backgroundLight = light;

  static const textPrimary   = Color(0xFF1A202C);
  static const textSecondary = Color(0xFF718096);
  static const textHint      = Color(0xFFA0AEC0);
  static const divider       = Color(0xFFE2E8F0);

  // ── Semantic aliases — dark ────────────────────────────────────────────────
  static const surfaceDark        = Color(0xFF1E2030);
  static const surfaceVariantDark = Color(0xFF2D3148);
  static const backgroundDark     = darkBlue;

  static const textPrimaryDark   = Color(0xFFF7FAFC);
  static const textSecondaryDark = Color(0xFFA0AEC0);
}
