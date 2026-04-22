// ============================================================
// KuroLabs — Raw Color Palette (private)
// Do not use these directly in app code.
// Use KuroLabsTheme extension or ThemeData roles instead.
// ============================================================

import 'package:flutter/material.dart';

/// Private raw palette. Apps access tokens via [KuroLabsTheme].
abstract final class KuroLabsPalette {
  // Paper surfaces
  static const paper         = Color(0xFFF5F0E8);
  static const paperRaised   = Color(0xFFFAF8F3);
  static const paperSunken   = Color(0xFFEDE7DA);
  static const paperBorder   = Color(0xFFD0C4B0);
  static const paperDivider  = Color(0xFFE2DBD0);

  // Ink text scale
  static const ink1          = Color(0xFF1C1612);
  static const ink2          = Color(0xFF5C4F3D);
  static const ink3          = Color(0xFF9C8C78);
  static const ink4          = Color(0xFFC4B8A6);

  // App primaries
  static const hubAmber      = Color(0xFFB07030);
  static const hubAmberSoft  = Color(0xFFF0E2C8);

  static const questifyRed      = Color(0xFFB83C3C);
  static const questifyRedSoft  = Color(0xFFF5E0E0);

  static const omoiIndigo      = Color(0xFF3D5A9E);
  static const omoiIndigoSoft  = Color(0xFFDCE4F5);
}
