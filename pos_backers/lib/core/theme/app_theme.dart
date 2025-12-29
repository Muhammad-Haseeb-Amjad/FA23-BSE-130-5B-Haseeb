import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFF18700);
  static const primaryDark = Color(0xFFB25A00);
  static const accent = Color(0xFF2D3142);
  static const surface = Color(0xFFF8F5F2);
  static const card = Colors.white;
  static const success = Color(0xFF2EB67D);
  static const danger = Color(0xFFE54B4B);
  static const muted = Color(0xFF8A8D9F);
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: false);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.surface,
    primaryColor: AppColors.primary,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: AppColors.accent),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.accent),
      headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.accent),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.accent),
      titleTextStyle: TextStyle(
        color: AppColors.accent,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.muted),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    ),
  );
}
