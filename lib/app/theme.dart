import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// SECTION: Design System — Color Palette & Theme
// =============================================================================

/// Central color palette for the CryptoLearn app.
/// All UI files reference these constants — never hardcode colors elsewhere.
class AppColors {
  AppColors._();

  // Background layers
  static const bgDeep   = Color(0xFF050810);
  static const bgDark   = Color(0xFF0A0D1A);
  static const bgCard   = Color(0xFF111827);
  static const bgPanel  = Color(0xFF1C2333);

  // Primary accent — electric cyan
  static const cyan     = Color(0xFF00D4FF);
  static const cyanDim  = Color(0xFF003D4D);
  static const cyanGlow = Color(0x3300D4FF);

  // Secondary accent — neon green (terminal)
  static const green    = Color(0xFF00FF88);
  static const greenDim = Color(0xFF003322);

  // Warning / danger
  static const orange   = Color(0xFFFF8800);
  static const orangeDim= Color(0xFF3D2200);
  static const red      = Color(0xFFFF3366);
  static const redDim   = Color(0xFF3D0015);

  // Gold — for completed / achievement
  static const gold     = Color(0xFFFFD700);
  static const goldDim  = Color(0xFF3D3300);

  // Purple — asymmetric/RSA
  static const purple   = Color(0xFFAA44FF);
  static const purpleDim= Color(0xFF220044);

  // Neutral text
  static const textPrimary   = Color(0xFFE8EAF0);
  static const textSecondary = Color(0xFF8892AA);
  static const textMuted     = Color(0xFF445566);

  // Borders
  static const borderDefault = Color(0xFF1E2D44);
  static const borderActive  = Color(0xFF00D4FF);
}

// =============================================================================
// SECTION: Lesson accent colors — one per module
// =============================================================================

class LessonColors {
  LessonColors._();
  static const intro     = AppColors.cyan;
  static const caesar    = AppColors.orange;
  static const symmetric = AppColors.green;
  static const asymmetric= AppColors.purple;
  static const hashing   = AppColors.gold;
  static const network   = AppColors.red;
}

// =============================================================================
// SECTION: MaterialTheme builder
// =============================================================================

ThemeData buildAppTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bgDeep,
    colorScheme: const ColorScheme.dark(
      primary:   AppColors.cyan,
      secondary: AppColors.green,
      surface:   AppColors.bgCard,
      error:     AppColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        letterSpacing: 1.2,
      ),
      iconTheme: IconThemeData(color: AppColors.cyan),
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      bodyLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      bodyMedium: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      bodySmall: TextStyle(
        fontFamily: 'RobotoMono',
        color: AppColors.textMuted,
        fontSize: 11,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderDefault, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgPanel,
      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.cyan, width: 2),
      ),
    ),
    dividerColor: AppColors.borderDefault,
    iconTheme: const IconThemeData(color: AppColors.textSecondary),
  );
}

// =============================================================================
// SECTION: Typography helpers
// =============================================================================

class AppText {
  AppText._();

  static TextStyle mono(double size, Color color, [FontWeight? w]) => TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: size,
    color: color,
    fontWeight: w ?? FontWeight.normal,
    height: 1.5,
  );

  static TextStyle heading(double size, Color color) => TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    color: color,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle body(double size, Color color) => TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    color: color,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
}
