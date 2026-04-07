import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF4FC3F7);
  static const secondary = Color(0xFFFFB74D);
  static const success = Color(0xFF81C784);
  static const error = Color(0xFFEF5350);
  static const background = Color(0xFFFFF8E1);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF5D4037);
  static const textSecondary = Color(0xFF8D6E63);
  static const locked = Color(0xFFBDBDBD);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.notoSansScTextTheme().copyWith(
        displayLarge: GoogleFonts.notoSansSc(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.notoSansSc(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelLarge: GoogleFonts.notoSansSc(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.notoSansSc(
          fontSize: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
