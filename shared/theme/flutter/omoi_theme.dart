// ============================================================
// Omoi Theme — indigo primary + thought category tokens
// Layer 2: kurolabs_theme.dart knows nothing about thoughts.
//
// Usage:
//   MaterialApp(theme: OmoiThemeData.build(), ...)
//
// Access category tokens:
//   final o = OmoiTheme.of(context);
//   Badge(color: o.catPhilosophy)
// ============================================================

import 'package:flutter/material.dart';
import 'kurolabs_colors.dart';
import 'kurolabs_theme.dart';

// ── Thought domain extension ─────────────────────────────────
class OmoiTheme extends ThemeExtension<OmoiTheme> {
  const OmoiTheme({
    required this.catPhilosophy,
    required this.catPhilosophySoft,
    required this.catReading,
    required this.catReadingSoft,
    required this.catIdeas,
    required this.catIdeasSoft,
    required this.catWriting,
    required this.catWritingSoft,
    required this.catGeneral,
    required this.catGeneralSoft,
  });

  final Color catPhilosophy;
  final Color catPhilosophySoft;
  final Color catReading;
  final Color catReadingSoft;
  final Color catIdeas;
  final Color catIdeasSoft;
  final Color catWriting;
  final Color catWritingSoft;
  final Color catGeneral;
  final Color catGeneralSoft;

  static OmoiTheme of(BuildContext context) =>
      Theme.of(context).extension<OmoiTheme>()!;

  static const defaults = OmoiTheme(
    catPhilosophy:     Color(0xFF5840A0),
    catPhilosophySoft: Color(0xFFEDE8F5),
    catReading:        Color(0xFF3D7A52),
    catReadingSoft:    Color(0xFFEAF4EE),
    catIdeas:          Color(0xFF2D5A8E),
    catIdeasSoft:      Color(0xFFE8F0F9),
    catWriting:        Color(0xFFB85A20),
    catWritingSoft:    Color(0xFFF9ECE4),
    catGeneral:        Color(0xFF8C7A68),
    catGeneralSoft:    Color(0xFFF0EDE8),
  );

  @override
  OmoiTheme copyWith({
    Color? catPhilosophy, Color? catPhilosophySoft,
    Color? catReading, Color? catReadingSoft,
    Color? catIdeas, Color? catIdeasSoft,
    Color? catWriting, Color? catWritingSoft,
    Color? catGeneral, Color? catGeneralSoft,
  }) => OmoiTheme(
    catPhilosophy:     catPhilosophy     ?? this.catPhilosophy,
    catPhilosophySoft: catPhilosophySoft ?? this.catPhilosophySoft,
    catReading:        catReading        ?? this.catReading,
    catReadingSoft:    catReadingSoft    ?? this.catReadingSoft,
    catIdeas:          catIdeas          ?? this.catIdeas,
    catIdeasSoft:      catIdeasSoft      ?? this.catIdeasSoft,
    catWriting:        catWriting        ?? this.catWriting,
    catWritingSoft:    catWritingSoft    ?? this.catWritingSoft,
    catGeneral:        catGeneral        ?? this.catGeneral,
    catGeneralSoft:    catGeneralSoft    ?? this.catGeneralSoft,
  );

  @override
  OmoiTheme lerp(OmoiTheme? other, double t) {
    if (other == null) return this;
    return OmoiTheme(
      catPhilosophy:     Color.lerp(catPhilosophy, other.catPhilosophy, t)!,
      catPhilosophySoft: Color.lerp(catPhilosophySoft, other.catPhilosophySoft, t)!,
      catReading:        Color.lerp(catReading, other.catReading, t)!,
      catReadingSoft:    Color.lerp(catReadingSoft, other.catReadingSoft, t)!,
      catIdeas:          Color.lerp(catIdeas, other.catIdeas, t)!,
      catIdeasSoft:      Color.lerp(catIdeasSoft, other.catIdeasSoft, t)!,
      catWriting:        Color.lerp(catWriting, other.catWriting, t)!,
      catWritingSoft:    Color.lerp(catWritingSoft, other.catWritingSoft, t)!,
      catGeneral:        Color.lerp(catGeneral, other.catGeneral, t)!,
      catGeneralSoft:    Color.lerp(catGeneralSoft, other.catGeneralSoft, t)!,
    );
  }
}

// ── ThemeData builder ────────────────────────────────────────
abstract final class OmoiThemeData {
  static ThemeData build() => KuroLabsThemeData.build(
    primary:         KuroLabsPalette.omoiIndigo,
    primarySoft:     KuroLabsPalette.omoiIndigoSoft,
    extraExtensions: [OmoiTheme.defaults],
  );
}
