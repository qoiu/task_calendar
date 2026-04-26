
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectMainTheme {
  static const Color mainColor = Color(0xFF41FF00);
  static const Color surface = Color(0xFF070029);
  static const Color _inversePrimary = Color(0xFFF5F5F5);
  static const Color _grey = Color(0xFF8F8F8F);
  static const Color _greyLight = Color(0xFFE2E2E4);
  static const Color _black = mainColor;
  static const Color _error = Color(0xFFCE594F);
  static const Color errorContainer = Color(0xFFF2DADA);
  static const Color successContainer = Color(0xFFEFFFED);
  static const Color successColor = Color(0xFF34C759);
  static const Color badge = Color(0xFFD04646);
  static const Color progress = Color(0xFFFFAE00);
  static const Color _primaryContainer = Color(0xFFE0EEFF);

  static const _fontRoboto = 'Roboto_regular';
  static const _fontRobotoMedium = 'Roboto_medium';
  static const _fontRobotoSemiBold = 'Roboto_semibold';
  static const _fontRobotoMain = 'Roboto';

  static const fontRoboto = 'Roboto_regular';
  static const fontRobotoMedium = 'Roboto_medium';
  static const fontRobotoSemiBold = 'Roboto_semibold';
  static const fontRobotoMain = 'Roboto';
  static const titleLarge = TextStyle(
    fontFamily: _fontRobotoMain,
    fontSize: 24,
    fontWeight: FontWeight.w600, // "Мои анкеты", "Мои роли"
    color: _black,
  );

  static ThemeData theme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: surface,
      statusBarIconBrightness: Brightness.light, // Для Android
      statusBarBrightness: Brightness.dark, // Для iOS
    ),
  ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(_black.withAlpha(60)),
      thickness: WidgetStatePropertyAll(4),
      thumbVisibility: WidgetStatePropertyAll(false),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      filled: true,
      labelStyle: titleLarge,
      fillColor: WidgetStateColor.resolveWith((states) {
        return Colors.transparent;
      }),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: mainColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: mainColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: mainColor, width: 1),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: mainColor,
      inversePrimary: _inversePrimary,
      primaryContainer: _primaryContainer,
      onPrimary: surface,
      surfaceContainer: Colors.white,
      secondary: _inversePrimary,
      surface: surface,
      outline: _grey,
      onSurface: _black,
      inverseSurface: _inversePrimary,
      onInverseSurface: _greyLight,
      tertiaryFixed: Color(0xFF399272),
      error: _error,
      errorContainer: errorContainer
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _black,
      selectionColor: _greyLight.withAlpha(100),
      selectionHandleColor: mainColor,
    ),textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 18,
      fontWeight: FontWeight.w600, // Заголовок "Профиль"
      color: _black,
    ),
    titleMedium: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 20,
      fontWeight: FontWeight.w600, // "Мои анкеты", "Мои роли"
      color: _black,
    ),
    titleLarge: titleLarge,
    bodyLarge: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 14,
      fontWeight: FontWeight.w400, // Текст, email, телефон и т.п.
      color: _black,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 16,
      fontWeight: FontWeight.w400, // Подписи мелким шрифтом
      color: _black,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 22,
      fontWeight: FontWeight.w500, // Кнопки, "Анкета ученика"
      color: _black,
    ),
    // Заголовок крупный, жирный
    headlineLarge: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3, // немного увеличенный интерлиньяж
      color: _black,
    ),

    headlineMedium: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _black,
    ),

    // Текст на кнопках
    labelMedium: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 18,
      fontWeight: FontWeight.w300,
      letterSpacing: 0.2,
      color: _black,
    ),

    // Маленькие поясняющие тексты, если будут нужны
    bodySmall: TextStyle(
      fontFamily: _fontRobotoMain,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),
  );
}
