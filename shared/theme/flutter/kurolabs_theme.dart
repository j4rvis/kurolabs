// ============================================================
// KuroLabs — Base Semantic Theme
// Layer 1: app-agnostic. No quest/thought/XP concepts here.
//
// Usage:
//   MaterialApp(
//     theme: KuroLabsThemeData.build(primary: KuroLabsPalette.hubAmber),
//     ...
//   )
//
// Access tokens anywhere:
//   final t = KuroLabsTheme.of(context);
//   Container(color: t.surface)
// ============================================================

import 'package:flutter/material.dart';
import 'kurolabs_colors.dart';

// Font family constants — must match the family names declared in pubspec.yaml
const _kFontMono    = 'SyneMono';   // SyneMono-Regular.ttf
const _kFontDisplay = 'Cinzel';     // Cinzel-Regular.ttf, Cinzel-Bold.ttf

// ── Semantic ThemeExtension ───────────────────────────────────
/// Semantic design tokens for all KuroLabs apps.
/// Access via [KuroLabsTheme.of(context)].
class KuroLabsTheme extends ThemeExtension<KuroLabsTheme> {
  const KuroLabsTheme({
    required this.bg,
    required this.surface,
    required this.surfaceSunken,
    required this.border,
    required this.divider,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.textDisabled,
    required this.primary,
    required this.primarySoft,
  });

  final Color bg;
  final Color surface;
  final Color surfaceSunken;
  final Color border;
  final Color divider;
  final Color text;
  final Color textMuted;
  final Color textSubtle;
  final Color textDisabled;
  final Color primary;
  final Color primarySoft;

  /// Retrieve from context — throws if not found.
  static KuroLabsTheme of(BuildContext context) =>
      Theme.of(context).extension<KuroLabsTheme>()!;

  /// Base instance with hub amber as primary.
  static const defaults = KuroLabsTheme(
    bg:            KuroLabsPalette.paper,
    surface:       KuroLabsPalette.paperRaised,
    surfaceSunken: KuroLabsPalette.paperSunken,
    border:        KuroLabsPalette.paperBorder,
    divider:       KuroLabsPalette.paperDivider,
    text:          KuroLabsPalette.ink1,
    textMuted:     KuroLabsPalette.ink2,
    textSubtle:    KuroLabsPalette.ink3,
    textDisabled:  KuroLabsPalette.ink4,
    primary:       KuroLabsPalette.hubAmber,
    primarySoft:   KuroLabsPalette.hubAmberSoft,
  );

  @override
  KuroLabsTheme copyWith({
    Color? bg, Color? surface, Color? surfaceSunken,
    Color? border, Color? divider, Color? text, Color? textMuted,
    Color? textSubtle, Color? textDisabled, Color? primary, Color? primarySoft,
  }) => KuroLabsTheme(
    bg:            bg            ?? this.bg,
    surface:       surface       ?? this.surface,
    surfaceSunken: surfaceSunken ?? this.surfaceSunken,
    border:        border        ?? this.border,
    divider:       divider       ?? this.divider,
    text:          text          ?? this.text,
    textMuted:     textMuted     ?? this.textMuted,
    textSubtle:    textSubtle    ?? this.textSubtle,
    textDisabled:  textDisabled  ?? this.textDisabled,
    primary:       primary       ?? this.primary,
    primarySoft:   primarySoft   ?? this.primarySoft,
  );

  @override
  KuroLabsTheme lerp(KuroLabsTheme? other, double t) {
    if (other == null) return this;
    return KuroLabsTheme(
      bg:            Color.lerp(bg, other.bg, t)!,
      surface:       Color.lerp(surface, other.surface, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      border:        Color.lerp(border, other.border, t)!,
      divider:       Color.lerp(divider, other.divider, t)!,
      text:          Color.lerp(text, other.text, t)!,
      textMuted:     Color.lerp(textMuted, other.textMuted, t)!,
      textSubtle:    Color.lerp(textSubtle, other.textSubtle, t)!,
      textDisabled:  Color.lerp(textDisabled, other.textDisabled, t)!,
      primary:       Color.lerp(primary, other.primary, t)!,
      primarySoft:   Color.lerp(primarySoft, other.primarySoft, t)!,
    );
  }
}

// ── ThemeData builder ─────────────────────────────────────────
abstract final class KuroLabsThemeData {
  /// Build a [ThemeData] for any KuroLabs app.
  /// Pass [primary] and [primarySoft] to set the app accent color.
  /// Add app-specific [ThemeExtension]s via [extraExtensions].
  static ThemeData build({
    required Color primary,
    required Color primarySoft,
    List<ThemeExtension<dynamic>> extraExtensions = const [],
  }) {
    final semanticTheme = KuroLabsTheme.defaults.copyWith(
      primary:     primary,
      primarySoft: primarySoft,
    );

    final textTheme = _buildTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: _buildColorScheme(primary, primarySoft),
      textTheme: textTheme,
      scaffoldBackgroundColor: KuroLabsPalette.paper,

      // Cards
      cardTheme: CardTheme(
        color: KuroLabsPalette.paperRaised,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: KuroLabsPalette.paperBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KuroLabsPalette.paperSunken,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: KuroLabsPalette.paperBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: KuroLabsPalette.paperBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: primary),
        ),
        hintStyle: const TextStyle(
          fontFamily: _kFontMono,
          color: KuroLabsPalette.ink4,
          fontSize: 13,
        ),
      ),

      // Elevated button — filled primary
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(fontFamily: _kFontMono, fontSize: 12, letterSpacing: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),

      // Outlined button — ghost
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KuroLabsPalette.ink2,
          side: const BorderSide(color: KuroLabsPalette.paperBorder),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          textStyle: const TextStyle(fontFamily: _kFontMono, fontSize: 12, letterSpacing: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: KuroLabsPalette.paperDivider,
        thickness: 1,
        space: 1,
      ),

      // App bar — borderless, paper background
      appBarTheme: AppBarTheme(
        backgroundColor: KuroLabsPalette.paperRaised,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontFamily: _kFontMono,
          color: KuroLabsPalette.ink1,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: KuroLabsPalette.ink2),
        shape: const Border(
          bottom: BorderSide(color: KuroLabsPalette.paperDivider),
        ),
      ),

      // Bottom nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: KuroLabsPalette.paperRaised,
        selectedItemColor: primary,
        unselectedItemColor: KuroLabsPalette.ink3,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Navigation bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: KuroLabsPalette.paperRaised,
        indicatorColor: primarySoft,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primary);
          }
          return const IconThemeData(color: KuroLabsPalette.ink3);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          const base = TextStyle(fontFamily: _kFontMono, fontSize: 10, letterSpacing: 0.6);
          if (states.contains(WidgetState.selected)) {
            return base.copyWith(color: primary);
          }
          return base.copyWith(color: KuroLabsPalette.ink3);
        }),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: KuroLabsPalette.paperSunken,
        selectedColor: primarySoft,
        side: const BorderSide(color: KuroLabsPalette.paperBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        labelStyle: const TextStyle(
          fontFamily: _kFontMono,
          fontSize: 11,
          color: KuroLabsPalette.ink2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      extensions: [semanticTheme, ...extraExtensions],
    );
  }

  static ColorScheme _buildColorScheme(Color primary, Color primarySoft) =>
      ColorScheme.light(
        primary:          primary,
        onPrimary:        Colors.white,
        primaryContainer: primarySoft,
        onPrimaryContainer: primary,
        secondary:        KuroLabsPalette.ink2,
        onSecondary:      Colors.white,
        surface:          KuroLabsPalette.paper,
        onSurface:        KuroLabsPalette.ink1,
        surfaceContainerLow:    KuroLabsPalette.paperSunken,
        surfaceContainer:       KuroLabsPalette.paper,
        surfaceContainerHigh:   KuroLabsPalette.paperRaised,
        outline:          KuroLabsPalette.paperBorder,
        outlineVariant:   KuroLabsPalette.paperDivider,
        error:            const Color(0xFFB83C3C),
        onError:          Colors.white,
        shadow:           Colors.transparent,
        scrim:            Colors.black26,
      );

  static TextTheme _buildTextTheme() => TextTheme(
    // Display — Cinzel for logotype moments only
    displayLarge:  _cinzel(32, weight: FontWeight.w700, spacing: 3.0),
    displayMedium: _cinzel(24, weight: FontWeight.w700, spacing: 2.0),
    displaySmall:  _cinzel(18, weight: FontWeight.w400, spacing: 1.5),

    // Headlines — Syne Mono
    headlineLarge:  _mono(20, spacing: 1.5),
    headlineMedium: _mono(16, spacing: 1.2),
    headlineSmall:  _mono(14, spacing: 1.0),

    // Titles
    titleLarge:  _mono(14, spacing: 0.8),
    titleMedium: _mono(13, spacing: 0.6),
    titleSmall:  _mono(12, spacing: 0.5),

    // Body
    bodyLarge:   _mono(14, color: KuroLabsPalette.ink1),
    bodyMedium:  _mono(13, color: KuroLabsPalette.ink2),
    bodySmall:   _mono(11, color: KuroLabsPalette.ink3),

    // Labels
    labelLarge:  _mono(12, spacing: 0.6),
    labelMedium: _mono(10, spacing: 0.5),
    labelSmall:  _mono(9,  spacing: 0.8),
  );

  static TextStyle _mono(double size, {
    Color color = KuroLabsPalette.ink1,
    double spacing = 0.3,
  }) => TextStyle(
    fontFamily: _kFontMono,
    fontSize: size,
    color: color,
    letterSpacing: spacing,
    height: 1.5,
  );

  static TextStyle _cinzel(double size, {
    FontWeight weight = FontWeight.w400,
    double spacing = 1.0,
  }) => TextStyle(
    fontFamily: _kFontDisplay,
    fontSize: size,
    fontWeight: weight,
    color: KuroLabsPalette.ink1,
    letterSpacing: spacing,
  );
}
