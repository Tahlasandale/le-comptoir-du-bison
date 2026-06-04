import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color cream = Color(0xFFF5EDD8);
  static const Color parchment = Color(0xFFE8D9B8);
  static const Color aged = Color(0xFFD4C49A);
  static const Color ink = Color(0xFF1A1208);
  static const Color brownDark = Color(0xFF2D1A08);
  static const Color brownMid = Color(0xFF5C3317);
  static const Color brownLight = Color(0xFF8B5E3C);
  static const Color amber = Color(0xFFC8760A);
  static const Color amberLight = Color(0xFFE8A82A);
  static const Color foam = Color(0xFFFEF3C7);
  static const Color rust = Color(0xFF8B3A1A);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: brownDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: amber,
        primary: brownMid,
        secondary: amber,
        surface: parchment,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: brownDark,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: brownDark,
        ),
        bodyLarge: GoogleFonts.libreBaskerville(
          fontSize: 16,
          color: ink,
        ),
        bodyMedium: GoogleFonts.libreBaskerville(
          fontSize: 14,
          color: ink,
        ),
        labelSmall: GoogleFonts.specialElite(
          fontSize: 10,
          letterSpacing: 1.5,
          color: brownLight,
        ),
      ),
    );
  }
}
