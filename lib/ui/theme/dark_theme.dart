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

  // 🌑 Backgrounds
  static const Color surface = Color.fromRGBO(49, 46, 43, 1);
  static const Color surfaceContainer = Color.fromRGBO(39, 37, 34, 1);
  static const Color surfaceContainerHighest = Color.fromRGBO(86, 84, 82, 1);
  static const Color surfaceDim = Color.fromRGBO(29, 27, 26, 1);
  static const Color surfaceBright = Color.fromRGBO(79, 76, 73, 1);

  static const Color onSurface = white;
  static const Color onSurfaceVariant = Color.fromRGBO(180, 180, 180, 1);

  // 🎯 Accent principale (progression / coups)
  static const Color primary = Color.fromRGBO(112, 172, 53, 1);
  static const Color onPrimary = white;

  static const Color primaryContainer = Color(0xFF81C784);
  static const Color onPrimaryContainer = black;

  // 🏆 Secondaire (gamification / trophées)
  static const Color secondary = Color(0xFFFFC107);
  static const Color onSecondary = black;

  // 🔥 Tertiaire (actions / mise en avant)
  static const Color tertiary = Color(0xFFFB8500);
  static const Color onTertiary = black;

  // 🧱 Borders
  static const Color outline = Color.fromRGBO(141, 140, 139, 1);
  static const Color outlineVariant = Color.fromRGBO(100, 100, 100, 0.6);

  // ✅ Succès
  static const Color success = Color(0xFF00E676);

  // ❌ Erreur
  static const Color error = Color(0xFFF44336);
  static const Color onError = AppColors.white;

  // 🎨 Basiques
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  splashFactory: NoSplash.splashFactory,

  colorScheme: const ColorScheme.dark().copyWith(
    brightness: Brightness.dark,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
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
    error: AppColors.error,
    onError: AppColors.onError,
  ),

  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: AppColors.surfaceDim,
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
    backgroundColor: AppColors.surfaceDim,
    foregroundColor: AppColors.onSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    titleTextStyle: AppTextStyles.headlineLarge,
  ),

  // * Input
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceContainer,
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.circular(16),
    //   borderSide: const BorderSide(color: AppColors.outline, width: 2),
    // ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.outline, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: const TextStyle(color: AppColors.outline),
    labelStyle: const TextStyle(color: AppColors.outline),
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
