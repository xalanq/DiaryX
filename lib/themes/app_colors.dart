import 'package:flutter/material.dart';

/// App color palette according to the product design document
class AppColors {
  /// Private constructor to prevent instantiation
  AppColors._();

  static const Color iconAwesomeColor = Color.fromARGB(255, 255, 218, 106);

  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF8487E4); // Premium Light Purple
  static const Color lightSecondary = Color(0xFFA8AAF0); // Soft Purple
  static const Color lightBackground = Color(0xFFFAFBFF); // Off-white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure White
  static const Color lightAccent = Color(0xFF6366F1); // Vibrant Purple
  static const Color lightTextPrimary = Color(0xFF1F2937); // Dark Gray
  static const Color lightTextSecondary = Color(0xFF6B7280); // Medium Gray

  // Dark Theme Colors
  static const Color darkPrimary = Color(
    0xFF5B67D6,
  ); // Perfect Purple Blue (Avatar Color)
  static const Color darkSecondary = Color(0xFF7B85E6); // Harmonious Purple
  static const Color darkBackground = Color(
    0xFF0B0B0F,
  ); // Ultra Deep Blue Black
  static const Color darkSurface = Color(0xFF161622); // Deep Blue Gray Surface
  static const Color darkAccent = Color(0xFF454FA7); // Complementary Purple
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Pure White
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Soft Gray

  // Common Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Glass Morphism Background Gradients
  static const List<Color> glassMorphismLightGradient = [
    Color(0xFFF8FAFC), // Ultra light
    Color(0xFFE2E8F0), // Light gray
  ];

  static const List<Color> glassMorphismDarkGradient = [
    Color(0x3B141A24), // Deep dark
    Color(0x3B171F2D), // Dark gray
  ];

  // Light theme gradients
  static const List<Color> primaryGradient = [
    Color(0xFF4776E6), // Blue
    Color(0xFF8E54E9), // Purple
  ];

  static const List<Color> accentGradient = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Purple
  ];

  // Dark theme gradients (enhanced for dark mode)
  static const List<Color> primaryGradientDark = [
    Color.fromARGB(255, 85, 87, 234), // Brighter Indigo for dark mode
    Color.fromARGB(255, 153, 85, 247), // Brighter Purple for dark mode
  ];

  static const List<Color> accentGradientDark = [
    Color(0xFF3B82F6), // Electric Blue for dark mode
    Color.fromARGB(255, 128, 90, 216), // Purple for dark mode
  ];

  // Glass Morphism specific colors
  static const Color glassLight = Color(0xFFFFFFFF);
  static const Color glassDark = Color(0xFF141A24);
  static const Color glassBorder = Color(0x00FFFFFF);
  static const Color glassBorderDark = Color(0xFF3B4C62);

  // Shadow colors for floating elements
  static const Color shadowLight = Color.fromRGBO(0, 0, 0, 0.02);
  static const Color shadowDark = Color.fromRGBO(0, 0, 0, 0.1);

  // Convenience getters for theme-aware gradients
  static List<Color> getPrimaryGradient(bool isDark) {
    return isDark ? primaryGradientDark : primaryGradient;
  }

  static List<Color> getAccentGradient(bool isDark) {
    return isDark ? accentGradientDark : accentGradient;
  }

  static List<Color> getGlassMorphismGradient(bool isDark) {
    return isDark ? glassMorphismDarkGradient : glassMorphismLightGradient;
  }

  // Divider Colors
  static const Color lightDivider = Color(0xFFD5D7DC); // Very light gray
  static const Color darkDivider = Color(
    0xFF3B4C62,
  ); // Dark gray for dark theme
}
