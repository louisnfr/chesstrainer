import 'package:flutter/material.dart';

@immutable
class AppColors {
  const AppColors._();

  // Fond principal
  static const Color surface = Color.fromRGBO(50, 46, 43, 1);

  static const Color primary = Color.fromRGBO(28, 176, 246, 1);
  static const Color onPrimary = Color.fromRGBO(255, 255, 255, 1);

  static const Color secondary = Color.fromRGBO(103, 58, 183, 1);
  static const Color onSecondary = Color.fromRGBO(224, 224, 224, 1);

  static const Color tertiary = Color.fromRGBO(79, 79, 79, 1);
  static const Color onTertiary = Color.fromRGBO(255, 255, 255, 1);

  static const Color success = Color.fromRGBO(255, 235, 59, 1);

  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,

  colorScheme: const ColorScheme.dark().copyWith(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    onPrimary: AppColors.onPrimary,
    onSecondary: AppColors.onSecondary,
    onSurface: AppColors.onPrimary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
  ),

  textTheme: const TextTheme(
    // ************ Display text styles ************
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),

    // ************ Headline text styles ************
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),

    // ************ Title text styles ************
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),

    // ************ Body text styles ************
    bodyLarge: TextStyle(
      fontSize: 18,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),

    // ************ Label text styles ************
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.onPrimary,
      fontFamily: 'Nunito',
    ),
  ),
);
