import 'dart:async';
import 'dart:convert';
import '../databases/app_database.dart';
import '../utils/app_logger.dart';

/// Draft data model
class DraftData {
  final String content;
  final String? mood;
  final DateTime lastModified;

  DraftData({required this.content, this.mood, required this.lastModified});

  Map<String, dynamic> toJson() => {
    'content': content,
    'mood': mood,
    'lastModified': lastModified.toIso8601String(),
  };

  factory DraftData.fromJson(Map<String, dynamic> json) => DraftData(
    content: json['content'] ?? '',
    mood: json['mood'],
    lastModified: DateTime.parse(json['lastModified']),
  );
}

/// Service for managing text moment drafts
class DraftService {
  static const String _draftKey = 'text_moment_draft';

  final AppDatabase _database = AppDatabase.instance;

  /// Save draft to keyValues table
  Future<void> saveDraft({required String content, String? mood}) async {
    try {
      final draftData = DraftData(
        content: content.trim(),
        mood: mood,
        lastModified: DateTime.now(),
      );

      if (draftData.content.isEmpty && draftData.mood == null) {
        // Clear draft if both content and mood are empty
        await clearDraft();
        return;
      }

      final jsonString = jsonEncode(draftData.toJson());
      await _database.setValue(_draftKey, jsonString);

      AppLogger.info(
        'Saved text moment draft: ${content.length} chars, mood: $mood',
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
        'Loaded text moment draft: ${draft.content.length} chars, mood: ${draft.mood}',
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
      return draft != null && (draft.content.isNotEmpty || draft.mood != null);
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

  void autoSaveDraft({required String content, String? mood}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_autoSaveDelay, () {
      saveDraft(content: content, mood: mood);
    });
  }

  /// Cancel any pending auto-save
  void cancelAutoSave() {
    _debounceTimer?.cancel();
  }
}
