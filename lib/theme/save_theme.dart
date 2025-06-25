// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6A1B9A); // Deep Purple
  static const Color accentColor = Color(0xFFD4E157); // Lime Green Accent
  static const Color backgroundColor = Color(0xFFF3F4F6); // Light Gray Background
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF333333); // Dark Gray for text
  static const Color successColor = Color(0xFF4CAF50); // Green
  static const Color errorColor = Color(0xFFF44336); // Red

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 4,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
          fontSize: 96, fontWeight: FontWeight.w300, color: textColor),
      displayMedium: GoogleFonts.inter(
          fontSize: 60, fontWeight: FontWeight.w400, color: textColor),
      displaySmall: GoogleFonts.inter(
          fontSize: 48, fontWeight: FontWeight.w400, color: textColor),
      headlineMedium: GoogleFonts.inter(
          fontSize: 34, fontWeight: FontWeight.w400, color: textColor),
      headlineSmall: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w500, color: textColor),
      titleLarge: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w500, color: textColor),
      bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, color: textColor),
      bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
      labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white), // For buttons
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 6, // Add some shadow
        shadowColor: primaryColor.withOpacity(0.4),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor,
      selectionHandleColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: textColor.withOpacity(0.7)),
      hintStyle: GoogleFonts.inter(color: textColor.withOpacity(0.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
      unselectedLabelStyle: GoogleFonts.inter(),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
