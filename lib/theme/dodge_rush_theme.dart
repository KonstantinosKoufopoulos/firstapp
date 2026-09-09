import 'package:flutter/material.dart';

abstract final class DodgeRushColors {
  static const background = Color(0xFF0B0F1A);
  static const surface = Color(0xFF151B2E);
  static const primary = Color(0xFF7C5CFF);
  static const accent = Color(0xFF00E5A8);
  static const danger = Color(0xFFFF4D6A);
  static const coin = Color(0xFFFFC857);
  static const text = Color(0xFFF2F4FF);
  static const muted = Color(0xFF8B93B0);
}

abstract final class DodgeRushTokens {
  static const radius = 16.0;
  static const ctaHeight = 52.0;
  static const padding = 20.0;
  static const bannerSafeZone = 50.0;

  static const pagePadding = EdgeInsets.all(padding);
  static const roundedShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

abstract final class DodgeRushTheme {
  static ThemeData get dark {
    const colors = ColorScheme.dark(
      surface: DodgeRushColors.surface,
      primary: DodgeRushColors.primary,
      secondary: DodgeRushColors.accent,
      error: DodgeRushColors.danger,
      onSurface: DodgeRushColors.text,
      onPrimary: DodgeRushColors.text,
      onSecondary: DodgeRushColors.background,
      onError: DodgeRushColors.text,
    );

    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: colors,
      scaffoldBackgroundColor: DodgeRushColors.background,
      useMaterial3: true,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: DodgeRushColors.text,
        displayColor: DodgeRushColors.text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: DodgeRushColors.text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: DodgeRushColors.text,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DodgeRushColors.surface,
        elevation: 0,
        margin: EdgeInsets.only(bottom: 12),
        shape: DodgeRushTokens.roundedShape,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(DodgeRushTokens.ctaHeight),
          backgroundColor: DodgeRushColors.primary,
          foregroundColor: DodgeRushColors.text,
          disabledBackgroundColor: DodgeRushColors.surface,
          disabledForegroundColor: DodgeRushColors.muted,
          shape: DodgeRushTokens.roundedShape,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(DodgeRushTokens.ctaHeight),
          foregroundColor: DodgeRushColors.text,
          side: const BorderSide(color: DodgeRushColors.muted),
          shape: DodgeRushTokens.roundedShape,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DodgeRushColors.muted,
          minimumSize: const Size(0, DodgeRushTokens.ctaHeight),
          shape: DodgeRushTokens.roundedShape,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: DodgeRushColors.text,
        iconColor: DodgeRushColors.primary,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: DodgeRushTokens.roundedShape,
      ),
      dividerColor: DodgeRushColors.muted,
      iconTheme: const IconThemeData(color: DodgeRushColors.text),
    );
  }
}
