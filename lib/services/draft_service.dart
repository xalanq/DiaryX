import 'dart:async';
import 'dart:convert';
import '../databases/app_database.dart';
import '../utils/app_logger.dart';

/// Draft data model
class DraftData {
  final String content;
  final List<String> moods;
  final DateTime lastModified;

  DraftData({
    required this.content,
    List<String>? moods,
    required this.lastModified,
  }) : moods = moods ?? [];

  Map<String, dynamic> toJson() => {
    'content': content,
    'moods': moods,
    'lastModified': lastModified.toIso8601String(),
  };

  factory DraftData.fromJson(Map<String, dynamic> json) {
    List<String> parsedMoods = [];

    // Handle backward compatibility - check for both old 'mood' and new 'moods'
    if (json.containsKey('moods') && json['moods'] is List) {
      parsedMoods = List<String>.from(json['moods']);
    } else if (json.containsKey('mood') && json['mood'] != null) {
      // Legacy single mood support
      parsedMoods = [json['mood'] as String];
    }

    return DraftData(
      content: json['content'] ?? '',
      moods: parsedMoods,
      lastModified: DateTime.parse(json['lastModified']),
    );
  }
}

/// Service for managing text moment drafts
class DraftService {
  static const String _draftKey = 'text_moment_draft';

  final AppDatabase _database = AppDatabase.instance;

  /// Save draft to keyValues table
  Future<void> saveDraft({required String content, List<String>? moods}) async {
    try {
      final draftData = DraftData(
        content: content.trim(),
        moods: moods,
        lastModified: DateTime.now(),
      );

      if (draftData.content.isEmpty && draftData.moods.isEmpty) {
        // Clear draft if both content and moods are empty
        await clearDraft();
        return;
      }

      final jsonString = jsonEncode(draftData.toJson());
      await _database.setValue(_draftKey, jsonString);

      AppLogger.info(
        'Saved text moment draft: ${content.length} chars, moods: ${moods?.join(", ") ?? "none"}',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save draft', e, stackTrace);
    }
  }

  /// Load draft from keyValues table
  Future<DraftData?> loadDraft() async {
    try {
      final jsonString = await _database.getValue(_draftKey);
      if (jsonString == null) {
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final draft = DraftData.fromJson(json);

      AppLogger.info(
        'Loaded text moment draft: ${draft.content.length} chars, moods: ${draft.moods.join(", ")}',
      );
      return draft;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load draft', e, stackTrace);
      return null;
    }
  }

  /// Clear draft from keyValues table
  Future<void> clearDraft() async {
    try {
      await _database.deleteValue(_draftKey);
      AppLogger.info('Cleared text moment draft');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear draft', e, stackTrace);
    }
  }

  /// Check if draft exists
  Future<bool> hasDraft() async {
    try {
      final draft = await loadDraft();
      return draft != null &&
          (draft.content.isNotEmpty || draft.moods.isNotEmpty);
    } catch (e) {
      return false;
    }
  }

  /// Get draft age in minutes
  Future<int?> getDraftAgeMinutes() async {
    try {
      final draft = await loadDraft();
      if (draft == null) return null;

      final now = DateTime.now();
      final difference = now.difference(draft.lastModified);
      return difference.inMinutes;
    } catch (e) {
      return null;
    }
  }

  /// Auto-save draft with debouncing
  static const Duration _autoSaveDelay = Duration(seconds: 2);
  static Timer? _debounceTimer;

  void autoSaveDraft({required String content, List<String>? moods}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_autoSaveDelay, () {
      saveDraft(content: content, moods: moods);
    });
  }

  /// Cancel any pending auto-save
  void cancelAutoSave() {
    _debounceTimer?.cancel();
  }
}
