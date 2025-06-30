// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Core Color Palette (tuned for the new design) ---
  static const Color primaryColor = Color(0xFF673AB7); // A slightly different, vibrant purple
  static const Color accentColor = Color(0xFF8E24AA); // A deeper, more impactful purple for accents
  static const Color backgroundColor = Color(0xFFF9F9F9); // Very light, almost white background
  static const Color cardColor = Colors.white; // Used for content containers
  static const Color textColor = Color(0xFF333333); // Dark grey for general text
  static const Color lightText = Color(0xFF888888); // Lighter grey for secondary text/hints
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  // --- Specific utility colors (refined for the new design) ---
  static const Color nearlyWhite = Color(0xFFFDFDFD); // Even lighter for backgrounds of fill areas
  static const Color lightGrey = Color(0xFFE0E0E0); // A general light grey for borders, dividers, etc.
  static const Color sectionBorderColor = Color(0xFFEEEEEE); // Very light border for content sections


  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    useMaterial3: true, // Keep Material 3
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor, // Ensure secondary is set for accent elements
      surface: cardColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textColor,
      onBackground: textColor,
      onError: Colors.white,
    ),

    // --- AppBarTheme (Customized for the new header) ---
    appBarTheme: AppBarTheme(
      color: primaryColor, // This color will be used if a default AppBar is rendered
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 24, // Slightly larger for impact
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      centerTitle: true,
    ),

    // --- TextTheme (Refined for hierarchy and readability) ---
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 96, fontWeight: FontWeight.w300, color: textColor),
      displayMedium: GoogleFonts.inter(fontSize: 60, fontWeight: FontWeight.w400, color: textColor),
      displaySmall: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w400, color: textColor),
      headlineMedium: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, color: textColor), // For term title
      headlineSmall: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700, color: textColor), // For Glossary title
      titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: textColor), // Section titles
      titleMedium: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w500, color: lightText), // Subtitle/loading text
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textColor, height: 1.6), // Main body text
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
      labelLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white), // Action Chips text
    ),

    // --- ElevatedButtonThemeData (Used for modal close button) ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 4,
        shadowColor: primaryColor.withOpacity(0.3),
      ),
    ),

    // --- Text Selection Theme ---
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: accentColor, // Using accent for cursor
      selectionColor: accentColor,
      selectionHandleColor: accentColor,
    ),

    // --- InputDecorationTheme (For Search Bar) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: nearlyWhite, // Background of the TextField
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), // Matching the search bar container
        borderSide: BorderSide.none, // No default border
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none, // This is handled by the parent Container's border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: accentColor, width: 2), // Accent color on focus
      ),
      labelStyle: GoogleFonts.inter(color: lightText),
      hintStyle: GoogleFonts.inter(color: lightText.withOpacity(0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // --- CardTheme (Minimal use, potentially for bottom sheet or other pop-ups) ---
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 6, // Slightly reduced
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero, // Default margin for Card is now zero, control with padding/Container
    ),

    // --- Bottom Navigation Bar Theme (if used elsewhere) ---
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),

    // --- Additional Styling for Consistency ---
    dividerTheme: const DividerThemeData(
      color: sectionBorderColor, // Lighter divider for content separation
      thickness: 1.5,
      space: 20,
    ),
    iconTheme: const IconThemeData(
      color: textColor, // Default icon color, overridden where needed
    ),
  );
}