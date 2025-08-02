import 'package:flutter/material.dart';

/// App color palette according to the product design document
class AppColors {
  /// Private constructor to prevent instantiation
  AppColors._();

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

  // Divider Colors
  static const Color lightDivider = Color(0xFFD5D7DC); // Very light gray
  static const Color darkDivider = Color(
    0xFF374151,
  ); // Dark gray for dark theme

  // Emotion Colors for mood indicators
  static const Color emotionHappy = Color(0xFFFDE047);
  static const Color emotionSad = Color(0xFF3B82F6);
  static const Color emotionAngry = Color(0xFFEF4444);
  static const Color emotionExcited = Color(0xFFEC4899);
  static const Color emotionCalm = Color(0xFF10B981);
  static const Color emotionAnxious = Color(0xFFF59E0B);
  static const Color emotionNeutral = Color(0xFF6B7280);

  /// Get emotion color by emotion name
  static Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return emotionHappy;
      case 'sad':
        return emotionSad;
      case 'angry':
        return emotionAngry;
      case 'excited':
        return emotionExcited;
      case 'calm':
        return emotionCalm;
      case 'anxious':
        return emotionAnxious;
      default:
        return emotionNeutral;
    }
  }
}
