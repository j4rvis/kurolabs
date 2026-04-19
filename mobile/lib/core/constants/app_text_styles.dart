import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Headers / Quest titles — Cinzel
  static TextStyle displayLarge = GoogleFonts.cinzel(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.inkBrown,
    letterSpacing: 1.5,
  );

  static TextStyle displayMedium = GoogleFonts.cinzel(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.inkBrown,
    letterSpacing: 1.2,
  );

  static TextStyle questTitle = GoogleFonts.cinzel(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.inkBrown,
    letterSpacing: 0.8,
  );

  static TextStyle sectionHeader = GoogleFonts.cinzel(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.inkBrownLight,
    letterSpacing: 1.5,
  );

  // Body / descriptions — IM Fell English
  static TextStyle bodyLarge = GoogleFonts.imFellEnglish(
    fontSize: 16,
    color: AppColors.inkBrown,
  );

  static TextStyle bodyMedium = GoogleFonts.imFellEnglish(
    fontSize: 14,
    color: AppColors.inkBrown,
  );

  static TextStyle bodySmall = GoogleFonts.imFellEnglish(
    fontSize: 12,
    color: AppColors.inkBrownLight,
  );

  static TextStyle italic = GoogleFonts.imFellEnglish(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    color: AppColors.inkBrownLight,
  );

  // Ability score numbers — Uncial Antiqua
  static TextStyle statModifier = GoogleFonts.uncialAntiqua(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: AppColors.inkBrown,
  );

  static TextStyle statScore = GoogleFonts.uncialAntiqua(
    fontSize: 14,
    color: AppColors.inkBrownLight,
  );

  static TextStyle statLabel = GoogleFonts.cinzel(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: AppColors.inkBrownLight,
  );

  // XP / gold values
  static TextStyle xpValue = GoogleFonts.cinzel(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.goldAccent,
    letterSpacing: 0.5,
  );

  static TextStyle levelBadge = GoogleFonts.cinzel(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.parchment,
    letterSpacing: 1.0,
  );

  // UI labels — Crimson Text
  static TextStyle label = GoogleFonts.crimsonText(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.inkBrown,
    letterSpacing: 0.3,
  );

  static TextStyle caption = GoogleFonts.crimsonText(
    fontSize: 12,
    color: AppColors.inkBrownLight,
  );

  static TextStyle button = GoogleFonts.cinzel(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );
}
