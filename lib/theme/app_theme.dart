import 'package:flutter/material.dart';

class AppTheme {
  // Terminal Occultism Color Palette
  static const Color terminalBlack = Color(0xFF0A0E14);
  static const Color deepPurple = Color(0xFF1A0F2E);
  static const Color darkBlue = Color(0xFF0D1B2A);
  static const Color electricCyan = Color(0xFF00F5FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color darkGray = Color(0xFF1E2128);
  static const Color midGray = Color(0xFF2E3440);
  static const Color lightGray = Color(0xFF4C566A);
  static const Color textWhite = Color(0xFFE5E9F0);
  static const Color textGray = Color(0xFFD8DEE9);

  // Scoring colors
  static const Color scoreExcellent = Color(0xFF39FF14); // Neon green
  static const Color scoreGood = Color(0xFF00F5FF); // Cyan
  static const Color scoreFair = Color(0xFFFFD700); // Yellow
  static const Color scorePoor = Color(0xFFFF8C00); // Orange
  static const Color scoreAvoid = Color(0xFFFF073A); // Red

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: electricCyan,
      scaffoldBackgroundColor: terminalBlack,
      colorScheme: ColorScheme.dark(
        primary: electricCyan,
        secondary: neonGreen,
        surface: darkGray,
        error: scoreAvoid,
        onPrimary: terminalBlack,
        onSecondary: terminalBlack,
        onSurface: textWhite,
        onError: textWhite,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: deepPurple,
        foregroundColor: electricCyan,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: electricCyan,
          letterSpacing: 2,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: darkGray,
        elevation: 4,
        shadowColor: electricCyan.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: electricCyan.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),

      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: electricCyan,
          letterSpacing: 1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        displaySmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textWhite,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textWhite,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textWhite,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textGray,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textGray,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textWhite,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: electricCyan.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: electricCyan.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: electricCyan, width: 2),
        ),
        labelStyle: const TextStyle(color: textGray),
        hintStyle: TextStyle(color: textGray.withOpacity(0.6)),
      ),

      // Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricCyan,
          foregroundColor: terminalBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: electricCyan,
          side: const BorderSide(color: electricCyan, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: neonGreen,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: electricCyan,
        size: 24,
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonGreen,
        foregroundColor: terminalBlack,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: deepPurple,
        selectedItemColor: electricCyan,
        unselectedItemColor: textGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: darkGray,
        selectedColor: electricCyan.withOpacity(0.2),
        labelStyle: const TextStyle(color: textWhite),
        side: BorderSide(color: electricCyan.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: electricCyan.withOpacity(0.2),
        thickness: 1,
      ),
    );
  }

  // Get color based on Ray Peat score
  static Color getScoreColor(double score) {
    if (score >= 80) return scoreExcellent;
    if (score >= 60) return scoreGood;
    if (score >= 40) return scoreFair;
    if (score >= 20) return scorePoor;
    return scoreAvoid;
  }

  // Monospace text style for metrics
  static const TextStyle monoMetric = TextStyle(
    fontFamily: 'monospace',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle monoSmall = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    letterSpacing: 1,
  );
}
