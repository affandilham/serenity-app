import 'package:flutter/material.dart';

import 'app_tokens.dart';

abstract final class AppTheme {
  static const _accent = Color(0xFF5C7C67);
  static const _lightBackground = Color(0xFFF7F7F5);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightMutedSurface = Color(0xFFF0F0ED);
  static const _lightText = Color(0xFF171717);
  static const _lightSecondaryText = Color(0xFF6B6B68);
  static const _lightBorder = Color(0xFFE5E5E1);
  static const _darkBackground = Color(0xFF111110);
  static const _darkSurface = Color(0xFF1A1A18);
  static const _darkMutedSurface = Color(0xFF22221F);
  static const _darkText = Color(0xFFF4F4F0);
  static const _darkSecondaryText = Color(0xFFA7A79F);
  static const _darkBorder = Color(0xFF30302C);

  static ThemeData get light => _build(
    brightness: Brightness.light,
    background: _lightBackground,
    surface: _lightSurface,
    mutedSurface: _lightMutedSurface,
    text: _lightText,
    secondaryText: _lightSecondaryText,
    border: _lightBorder,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    background: _darkBackground,
    surface: _darkSurface,
    mutedSurface: _darkMutedSurface,
    text: _darkText,
    secondaryText: _darkSecondaryText,
    border: _darkBorder,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color mutedSurface,
    required Color text,
    required Color secondaryText,
    required Color border,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: _accent,
      onPrimary: Colors.white,
      secondary: _accent,
      onSecondary: Colors.white,
      error: const Color(0xFFB3261E),
      onError: Colors.white,
      surface: surface,
      onSurface: text,
    );

    final textTheme = Typography.material2021().black.apply(
      bodyColor: text,
      displayColor: text,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme.copyWith(
        displaySmall: textTheme.displaySmall?.copyWith(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          height: 1.12,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.45,
          color: secondaryText,
        ),
        bodySmall: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          height: 1.4,
          color: secondaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.button),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mutedSurface,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(AppRadius.medium),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(AppRadius.medium),
          borderSide: BorderSide(color: border),
        ),
      ),
    );
  }
}
