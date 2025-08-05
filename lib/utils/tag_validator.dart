/// Utility class for validating tag strings according to international standards
///
/// Supports Unicode characters from all languages including:
/// - Latin alphabet (English, European languages)
/// - Chinese characters (Simplified and Traditional)
/// - Japanese characters (Hiragana, Katakana, Kanji)
/// - Korean characters (Hangul)
/// - Arabic script
/// - Cyrillic script (Russian, etc.)
/// - Devanagari script (Hindi, Sanskrit, etc.)
/// - And many other Unicode scripts
class TagValidator {
  // Maximum tag length (Twitter standard)
  static const int maxTagLength = 100;

  // Minimum tag length
  static const int minTagLength = 1;

  /// Validates a tag string according to international standards
  ///
  /// Based on Twitter hashtag standards and Unicode recommendations:
  /// - Allows Unicode letters from all languages (\p{L})
  /// - Allows Unicode marks/diacritics for complex scripts (\p{M})
  /// - Allows Unicode decimal numbers (\p{Nd})
  /// - Allows underscore (_) for word separation
  /// - No whitespace characters
  /// - No punctuation except underscore
  /// - Cannot be only numbers
  /// - Cannot contain hash symbol (#)
  ///
  /// Returns null if valid, error message if invalid
  static String? validateTag(String tag) {
    // Check if empty or only whitespace
    if (tag.trim().isEmpty) {
      return 'Tag cannot be empty';
    }

    // Check length
    if (tag.length < minTagLength) {
      return 'Tag must be at least $minTagLength character';
    }

    if (tag.length > maxTagLength) {
      return 'Tag must be no more than $maxTagLength characters';
    }

    // Check for whitespace characters (space, tab, newline, etc.)
    if (tag.contains(RegExp(r'\s'))) {
      return 'Tag cannot contain spaces or whitespace characters';
    }

    // Check for hash symbol
    if (tag.contains('#')) {
      return 'Tag cannot contain hash symbol (#)';
    }

    // International standard validation using Unicode character classes
    // \p{L} = Unicode letters (all languages)
    // \p{M} = Unicode marks (combining diacritical marks, essential for many scripts)
    // \p{Nd} = Unicode decimal numbers
    // _ = underscore (allowed for word separation)
    final validCharPattern = RegExp(r'^[\p{L}\p{M}\p{Nd}_]+$', unicode: true);
    if (!validCharPattern.hasMatch(tag)) {
      return 'Tag can only contain letters, numbers, and underscores';
    }

    // Cannot be only numbers (Twitter standard)
    final onlyNumbersPattern = RegExp(r'^[\p{Nd}_]*$', unicode: true);
    if (onlyNumbersPattern.hasMatch(tag)) {
      return 'Tag cannot contain only numbers and underscores';
    }

    // Must contain at least one letter from any language
    final hasLetterPattern = RegExp(r'\p{L}', unicode: true);
    if (!hasLetterPattern.hasMatch(tag)) {
      return 'Tag must contain at least one letter';
    }

    return null; // Valid tag
  }

  /// Sanitizes a tag string by removing invalid characters
  /// Returns cleaned tag or null if it becomes invalid after cleaning
  ///
  /// Preserves Unicode letters and numbers from all languages
  static String? sanitizeTag(String tag) {
    // Remove leading/trailing whitespace
    String cleaned = tag.trim();

    // Remove hash symbols
    cleaned = cleaned.replaceAll('#', '');

    // Remove all whitespace characters
    cleaned = cleaned.replaceAll(RegExp(r'\s'), '');

    // Keep only valid characters: Unicode letters, marks, numbers, and underscore
    // This preserves characters from all languages including combining marks
    cleaned = cleaned.replaceAll(
      RegExp(r'[^\p{L}\p{M}\p{Nd}_]', unicode: true),
      '',
    );

    // Validate the cleaned tag
    final validationError = validateTag(cleaned);
    if (validationError != null) {
      return null;
    }

    return cleaned;
  }

  /// Checks if a tag is valid (convenience method)
  static bool isValidTag(String tag) {
    return validateTag(tag) == null;
  }
}
