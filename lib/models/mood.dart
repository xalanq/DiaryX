import 'package:flutter/material.dart';

/// Standard mood types used throughout the application (unified with 9 moods)
enum MoodType {
  happy,
  sad,
  calm,
  excited,
  anxious,
  thoughtful,
  grateful,
  angry,
  bored,
}

/// Mood option data class for UI components
class MoodOption {
  final String emoji;
  final String label;
  final Color color;
  final String value; // for storage

  const MoodOption({
    required this.emoji,
    required this.label,
    required this.color,
    required this.value,
  });
}

/// Mood colors for UI consistency (moved from AppColors)
class MoodColors {
  // Mood Colors for mood indicators (optimized for distinction)
  static const Color moodHappy = Color(0xFF22C55E); // Green
  static const Color moodSad = Color(0xFF3B82F6); // Blue
  static const Color moodCalm = Color(0xFF14B8A6); // Teal
  static const Color moodExcited = Color(0xFFF97316); // Orange
  static const Color moodAnxious = Color(0xFFEF4444); // Red
  static const Color moodThoughtful = Color(0xFF8B5CF6); // Purple
  static const Color moodGrateful = Color(0xFFF59E0B); // Amber
  static const Color moodAngry = Color(0xFFEC4899); // Pink
  static const Color moodBored = Color(0xFF6B7280); // Grey

  /// Get mood color by mood name
  static Color getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return moodHappy;
      case 'sad':
        return moodSad;
      case 'calm':
        return moodCalm;
      case 'excited':
        return moodExcited;
      case 'anxious':
        return moodAnxious;
      case 'thoughtful':
        return moodThoughtful;
      case 'grateful':
        return moodGrateful;
      case 'angry':
        return moodAngry;
      case 'bored':
        return moodBored;
      default:
        return moodBored; // Default to bored/neutral
    }
  }
}

/// Mood utility class for consistent mood handling
class MoodUtils {
  // Unified mood definitions with optimized emojis and distinct colors (9 moods total)
  static const List<MoodOption> _moodOptions = [
    // First row - Basic emotions
    MoodOption(
      emoji: '😊',
      label: 'Happy',
      color: MoodColors.moodHappy,
      value: 'happy',
    ),
    MoodOption(
      emoji: '😢',
      label: 'Sad',
      color: MoodColors.moodSad,
      value: 'sad',
    ),
    MoodOption(
      emoji: '😌',
      label: 'Calm',
      color: MoodColors.moodCalm,
      value: 'calm',
    ),
    // Second row - Intense emotions
    MoodOption(
      emoji: '🎉',
      label: 'Excited',
      color: MoodColors.moodExcited,
      value: 'excited',
    ),
    MoodOption(
      emoji: '😰',
      label: 'Anxious',
      color: MoodColors.moodAnxious,
      value: 'anxious',
    ),
    MoodOption(
      emoji: '🤔',
      label: 'Thoughtful',
      color: MoodColors.moodThoughtful,
      value: 'thoughtful',
    ),
    // Third row - Special emotions
    MoodOption(
      emoji: '🙏',
      label: 'Grateful',
      color: MoodColors.moodGrateful,
      value: 'grateful',
    ),
    MoodOption(
      emoji: '😠',
      label: 'Angry',
      color: MoodColors.moodAngry,
      value: 'angry',
    ),
    MoodOption(
      emoji: '😑',
      label: 'Bored',
      color: MoodColors.moodBored,
      value: 'bored',
    ),
  ];

  /// Get all available mood types
  static List<MoodType> get allMoods => MoodType.values;

  /// Get all mood options for UI display
  static List<MoodOption> get allMoodOptions => List.from(_moodOptions);

  /// Get mood option by string value
  static MoodOption? getMoodOptionByValue(String value) {
    try {
      return _moodOptions.firstWhere((option) => option.value == value);
    } catch (e) {
      return null;
    }
  }

  /// Get mood option by type
  static MoodOption? getMoodOptionByType(MoodType type) {
    return getMoodOptionByValue(type.name);
  }

  /// Parse mood from string value
  static MoodType? fromString(String? moodString) {
    if (moodString == null) return null;

    for (final type in MoodType.values) {
      if (type.name == moodString.toLowerCase()) {
        return type;
      }
    }
    return null;
  }

  /// Convert mood type to string for storage
  static String toStringValue(MoodType mood) => mood.name;

  /// Get mood emoji by string value
  static String getEmojiByValue(String value) {
    final option = getMoodOptionByValue(value);
    return option?.emoji ?? '😐';
  }

  /// Get mood color by string value
  static Color getColorByValue(String value) {
    final option = getMoodOptionByValue(value);
    return option?.color ?? Colors.grey;
  }

  /// Get mood label by string value
  static String getLabelByValue(String value) {
    final option = getMoodOptionByValue(value);
    return option?.label ?? 'Unknown';
  }
}
