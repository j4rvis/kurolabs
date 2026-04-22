// ============================================================
// Hub Theme — amber primary, no domain extensions
// ============================================================

import 'package:flutter/material.dart';
import 'kurolabs_colors.dart';
import 'kurolabs_theme.dart';

abstract final class HubThemeData {
  static ThemeData build() => KuroLabsThemeData.build(
    primary:     KuroLabsPalette.hubAmber,
    primarySoft: KuroLabsPalette.hubAmberSoft,
  );
}
