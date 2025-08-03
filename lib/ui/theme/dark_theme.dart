import 'package:flutter/material.dart';

@immutable
class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
    fontFamily: 'Nunito',
  );
}

@immutable
class AppColors {
  const AppColors._();

  // static const Color surface = Color.fromRGBO(41, 41, 41, 1);
  static const Color surface = Color.fromRGBO(37, 37, 37, 1);
  static const Color onSurface = AppColors.white;

  // static const Color surfaceContainer = Color.fromRGBO(108, 196, 217, 1);
  static const Color surfaceContainer = Color.fromRGBO(67, 67, 67, 1);

  static Color surfaceDim = surface.withValues(alpha: 0.8);

  static const Color primary = Color.fromRGBO(33, 158, 188, 1);
  static const Color onPrimary = AppColors.black;

  static const Color primaryContainer = Color.fromRGBO(142, 202, 230, 1);
  static const Color onPrimaryContainer = AppColors.black;

  static const Color secondary = Color.fromRGBO(255, 183, 3, 1);
  static const Color onSecondary = AppColors.black;

  static const Color tertiary = Color.fromRGBO(251, 133, 0, 1);
  static const Color onTertiary = AppColors.black;

  static const Color success = Color.fromRGBO(76, 170, 61, 1);

  static const Color outline = Color.fromRGBO(100, 100, 100, 1);
  static Color outlineVariant = outline.withValues(alpha: 0.6);

  static const Color black = Color.fromRGBO(0, 0, 0, 1);
  static const Color white = Color.fromRGBO(255, 255, 255, 1);
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,

  colorScheme: const ColorScheme.dark().copyWith(
    brightness: Brightness.dark,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceDim: AppColors.surfaceDim,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
  ),

  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: AppColors.surface,
    indicatorColor: Colors.transparent,
    labelPadding: EdgeInsets.all(0),
    labelTextStyle: WidgetStateProperty.fromMap({
      WidgetState.selected: TextStyle(
        color: AppColors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      WidgetState.any: TextStyle(
        color: AppColors.outline,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    }),
  ),

  // * App Bar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    titleTextStyle: AppTextStyles.headlineLarge,
  ),

  // * Chip Theme
  chipTheme: const ChipThemeData(),

  // * Text Theme
  textTheme: const TextTheme(
    // ************ Display text styles ************
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),

    // ************ Headline text styles ************
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),

    // ************ Title text styles ************
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),

    // ************ Body text styles ************
    bodyLarge: TextStyle(
      fontSize: 18,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),

    // ************ Label text styles ************
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
      fontFamily: 'Nunito',
    ),
  ),
);
