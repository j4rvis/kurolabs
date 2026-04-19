import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Parchment palette
  static const Color parchment = Color(0xFFF5E6C8);
  static const Color parchmentDark = Color(0xFFE8D5A3);
  static const Color parchmentBorder = Color(0xFFBFA07A);

  // Text
  static const Color inkBrown = Color(0xFF2C1810);
  static const Color inkBrownLight = Color(0xFF5C3D2E);

  // Accents
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFEDD97A);
  static const Color waxRed = Color(0xFF8B1A1A);
  static const Color royalBlue = Color(0xFF1A3A5C);
  static const Color forestGreen = Color(0xFF2D5016);

  // Difficulty colors
  static const Color diffTrivial = Color(0xFF9E9E9E);
  static const Color diffEasy = Color(0xFF2D5016);
  static const Color diffMedium = Color(0xFFF59E0B);
  static const Color diffHard = Color(0xFFD97706);
  static const Color diffDeadly = Color(0xFF8B1A1A);
  static const Color diffLegendary = Color(0xFF6B21A8);

  // Status
  static const Color success = Color(0xFF2D5016);
  static const Color danger = Color(0xFF8B1A1A);
  static const Color warning = Color(0xFFD97706);

  // Quest type accent colors
  static const Color daily = Color(0xFF1A3A5C);
  static const Color side = Color(0xFF5C4A1A);
  static const Color epic = Color(0xFF4A2C6E);

  static Color forDifficulty(String difficulty) {
    switch (difficulty) {
      case 'trivial':
        return diffTrivial;
      case 'easy':
        return diffEasy;
      case 'medium':
        return diffMedium;
      case 'hard':
        return diffHard;
      case 'deadly':
        return diffDeadly;
      case 'legendary':
        return diffLegendary;
      default:
        return diffMedium;
    }
  }

  static Color forQuestType(String type) {
    switch (type) {
      case 'daily':
        return daily;
      case 'side':
        return side;
      case 'epic':
        return epic;
      default:
        return side;
    }
  }
}
