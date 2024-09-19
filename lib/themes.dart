import 'package:flutter/material.dart';


class MainTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color shadow = Color(0x33262626);
  static const Color textColor = Color(0xFF212121);
  static const Color textColorWhite = Color(0xFFE2E2E2);
  static const Color accent = Color(0xFF339966);
  static const Color taskColor = Color(0xFF99FFCC);

  static ThemeData defaultLight = ThemeData(
    colorScheme: const ColorScheme.light(
        primary: accent,
        onPrimary: textColor,
        surface: white,
        secondary: taskColor,
        onSecondary: textColorWhite,
        outline: textColorWhite,
    ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accent.withOpacity(0.4),
        selectionHandleColor: accent),
    textTheme: TextTheme(
        bodyMedium: textMain14,
        bodySmall: textMain12,
        bodyLarge: textMain16,
        labelSmall: semibold12,
        labelMedium: semibold14,
        labelLarge: semibold16,
        titleSmall: bold12,
        titleMedium: bold14,
        titleLarge: bold16,
        headlineLarge: bold18),
  );
  static TextStyle textMain14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textColor,
    letterSpacing: 0.02,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  static TextStyle textMain16 = textMain14.copyWith(fontSize: 16);
  static TextStyle textMain12 = textMain14.copyWith(fontSize: 12);
  static TextStyle textMain10 = textMain14.copyWith(fontSize: 10);

  static TextStyle semibold14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: textColor,
    letterSpacing: 0.02,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  static TextStyle semibold16 = semibold14.copyWith(fontSize: 16);
  static TextStyle semibold12 = semibold14.copyWith(fontSize: 12);

  static TextStyle bold14 = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: textColor,
    letterSpacing: 0.2,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
  static TextStyle bold16 = bold14.copyWith(fontSize: 16);
  static TextStyle bold18 = bold14.copyWith(fontSize: 18);
  static TextStyle bold12 = bold14.copyWith(fontSize: 12);
}
