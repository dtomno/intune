import 'package:flutter/material.dart';

/// Guitar Tuna-inspired theme colors and settings
class AppThemes {
  // Primary colors - Guitar Tuna inspired
  static const Color primaryBlue = Color(0xFF0277BD);
  static const Color accentTeal = Color(0xFF00BCD4);
  static const Color vibrantOrange = Color(0xFFFFA000);
  static const Color deepPurple = Color(0xFF6A1B9A);
  static const Color warmRed = Color(0xFFE53935);
  
  // UI Surface colors
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  
  // Tuner-specific colors
  static const Color perfectTune = Color(0xFF4CAF50);
  static const Color slightlyOffTune = Color(0xFFFFEB3B);
  static const Color wayOffTune = Color(0xFFE53935);
  static const Color tunerNeedleColor = Color(0xFFE53935);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, accentTeal],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepPurple, accentTeal],
  );

  static const LinearGradient tunerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground, Color(0xFF263238)],
  );

  // Theme data
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: accentTeal,
        tertiary: vibrantOrange,
        background: lightBackground,
        surface: cardLight,
      ),
      scaffoldBackgroundColor: lightBackground,
      cardColor: cardLight,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardLight,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: accentTeal,
        secondary: primaryBlue,
        tertiary: vibrantOrange,
        background: darkBackground,
        surface: cardDark,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardColor: cardDark,
      appBarTheme: AppBarTheme(
        backgroundColor: cardDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: accentTeal,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentTeal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
      ),
    );
  }
  
  // Helper methods for theme-sensitive colors
  static Color getTuningColor(double accuracy, bool isDarkMode) {
    final absAccuracy = accuracy.abs();
    
    if (absAccuracy <= 0.1) {
      return perfectTune;
    } else if (absAccuracy <= 0.3) {
      return slightlyOffTune;
    } else {
      return wayOffTune;
    }
  }
  
  static Color getMainColor(bool isDarkMode) {
    return isDarkMode ? accentTeal : const Color.fromARGB(255, 2, 146, 230);
  }
  
  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? cardDark : cardLight;
  }
  
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? darkBackground : lightBackground;
  }
  
  static Color getTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.white : Colors.black87;
  }
  
  static Color getErrorColor() {
    return warmRed;
  }

  static Color getSuccessColor(bool isDarkMode) {
    return isDarkMode ? Color(0xFF00E676) : Color.fromARGB(255, 102, 213, 106);
  }

  static Color getWarningColor(bool isDarkMode) {
    return isDarkMode ? slightlyOffTune : Color.fromARGB(255, 170, 154, 10);
  }

  static Color getInactiveColor(bool isDarkMode) {
    return isDarkMode ? Colors.grey[700]! : Colors.grey[500]!;
  }
}