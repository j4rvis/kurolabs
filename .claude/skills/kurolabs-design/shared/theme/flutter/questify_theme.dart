// ============================================================
// Questify Theme — vermilion primary + quest domain tokens
// Layer 2: kurolabs_theme.dart knows nothing about quests.
//
// Usage:
//   MaterialApp(theme: QuestifyThemeData.build(), ...)
//
// Access quest tokens:
//   final q = QuestifyTheme.of(context);
//   Badge(color: q.diffEasy)
// ============================================================

import 'package:flutter/material.dart';
import 'kurolabs_colors.dart';
import 'kurolabs_theme.dart';

// ── Quest domain extension ───────────────────────────────────
class QuestifyTheme extends ThemeExtension<QuestifyTheme> {
  const QuestifyTheme({
    // Difficulty
    required this.diffTrivial,
    required this.diffTrivialSoft,
    required this.diffEasy,
    required this.diffEasySoft,
    required this.diffMedium,
    required this.diffMediumSoft,
    required this.diffHard,
    required this.diffHardSoft,
    required this.diffDeadly,
    required this.diffDeadlySoft,
    required this.diffLegendary,
    required this.diffLegendarySoft,
    // Quest type
    required this.typeDaily,
    required this.typeDailySoft,
    required this.typeSide,
    required this.typeSideSoft,
    required this.typeEpic,
    required this.typeEpicSoft,
  });

  // Difficulty
  final Color diffTrivial;
  final Color diffTrivialSoft;
  final Color diffEasy;
  final Color diffEasySoft;
  final Color diffMedium;
  final Color diffMediumSoft;
  final Color diffHard;
  final Color diffHardSoft;
  final Color diffDeadly;
  final Color diffDeadlySoft;
  final Color diffLegendary;
  final Color diffLegendarySoft;

  // Quest type
  final Color typeDaily;
  final Color typeDailySoft;
  final Color typeSide;
  final Color typeSideSoft;
  final Color typeEpic;
  final Color typeEpicSoft;

  static QuestifyTheme of(BuildContext context) =>
      Theme.of(context).extension<QuestifyTheme>()!;

  static const defaults = QuestifyTheme(
    diffTrivial:       Color(0xFF8A9099),
    diffTrivialSoft:   Color(0xFFF0F1F2),
    diffEasy:          Color(0xFF3D7A52),
    diffEasySoft:      Color(0xFFEAF4EE),
    diffMedium:        Color(0xFFB07030),
    diffMediumSoft:    Color(0xFFF9F0E4),
    diffHard:          Color(0xFFB85A20),
    diffHardSoft:      Color(0xFFF9ECE4),
    diffDeadly:        Color(0xFFB83C3C),
    diffDeadlySoft:    Color(0xFFF9E4E4),
    diffLegendary:     Color(0xFF7040A0),
    diffLegendarySoft: Color(0xFFF0EAF9),
    typeDaily:         Color(0xFF2D5A8E),
    typeDailySoft:     Color(0xFFE8F0F9),
    typeSide:          Color(0xFF3D7A52),
    typeSideSoft:      Color(0xFFEAF4EE),
    typeEpic:          Color(0xFF7040A0),
    typeEpicSoft:      Color(0xFFF0EAF9),
  );

  @override
  QuestifyTheme copyWith({
    Color? diffTrivial, Color? diffTrivialSoft,
    Color? diffEasy, Color? diffEasySoft,
    Color? diffMedium, Color? diffMediumSoft,
    Color? diffHard, Color? diffHardSoft,
    Color? diffDeadly, Color? diffDeadlySoft,
    Color? diffLegendary, Color? diffLegendarySoft,
    Color? typeDaily, Color? typeDailySoft,
    Color? typeSide, Color? typeSideSoft,
    Color? typeEpic, Color? typeEpicSoft,
  }) => QuestifyTheme(
    diffTrivial:       diffTrivial       ?? this.diffTrivial,
    diffTrivialSoft:   diffTrivialSoft   ?? this.diffTrivialSoft,
    diffEasy:          diffEasy          ?? this.diffEasy,
    diffEasySoft:      diffEasySoft      ?? this.diffEasySoft,
    diffMedium:        diffMedium        ?? this.diffMedium,
    diffMediumSoft:    diffMediumSoft    ?? this.diffMediumSoft,
    diffHard:          diffHard          ?? this.diffHard,
    diffHardSoft:      diffHardSoft      ?? this.diffHardSoft,
    diffDeadly:        diffDeadly        ?? this.diffDeadly,
    diffDeadlySoft:    diffDeadlySoft    ?? this.diffDeadlySoft,
    diffLegendary:     diffLegendary     ?? this.diffLegendary,
    diffLegendarySoft: diffLegendarySoft ?? this.diffLegendarySoft,
    typeDaily:         typeDaily         ?? this.typeDaily,
    typeDailySoft:     typeDailySoft     ?? this.typeDailySoft,
    typeSide:          typeSide          ?? this.typeSide,
    typeSideSoft:      typeSideSoft      ?? this.typeSideSoft,
    typeEpic:          typeEpic          ?? this.typeEpic,
    typeEpicSoft:      typeEpicSoft      ?? this.typeEpicSoft,
  );

  @override
  QuestifyTheme lerp(QuestifyTheme? other, double t) {
    if (other == null) return this;
    return QuestifyTheme(
      diffTrivial:       Color.lerp(diffTrivial, other.diffTrivial, t)!,
      diffTrivialSoft:   Color.lerp(diffTrivialSoft, other.diffTrivialSoft, t)!,
      diffEasy:          Color.lerp(diffEasy, other.diffEasy, t)!,
      diffEasySoft:      Color.lerp(diffEasySoft, other.diffEasySoft, t)!,
      diffMedium:        Color.lerp(diffMedium, other.diffMedium, t)!,
      diffMediumSoft:    Color.lerp(diffMediumSoft, other.diffMediumSoft, t)!,
      diffHard:          Color.lerp(diffHard, other.diffHard, t)!,
      diffHardSoft:      Color.lerp(diffHardSoft, other.diffHardSoft, t)!,
      diffDeadly:        Color.lerp(diffDeadly, other.diffDeadly, t)!,
      diffDeadlySoft:    Color.lerp(diffDeadlySoft, other.diffDeadlySoft, t)!,
      diffLegendary:     Color.lerp(diffLegendary, other.diffLegendary, t)!,
      diffLegendarySoft: Color.lerp(diffLegendarySoft, other.diffLegendarySoft, t)!,
      typeDaily:         Color.lerp(typeDaily, other.typeDaily, t)!,
      typeDailySoft:     Color.lerp(typeDailySoft, other.typeDailySoft, t)!,
      typeSide:          Color.lerp(typeSide, other.typeSide, t)!,
      typeSideSoft:      Color.lerp(typeSideSoft, other.typeSideSoft, t)!,
      typeEpic:          Color.lerp(typeEpic, other.typeEpic, t)!,
      typeEpicSoft:      Color.lerp(typeEpicSoft, other.typeEpicSoft, t)!,
    );
  }
}

// ── ThemeData builder ────────────────────────────────────────
abstract final class QuestifyThemeData {
  static ThemeData build() => KuroLabsThemeData.build(
    primary:          KuroLabsPalette.questifyRed,
    primarySoft:      KuroLabsPalette.questifyRedSoft,
    extraExtensions:  [QuestifyTheme.defaults],
  );
}
