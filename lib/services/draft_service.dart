import 'dart:async';
import 'dart:convert';
import '../databases/app_database.dart';
import '../utils/app_logger.dart';
import '../models/draft.dart';

/// Service for managing text moment drafts and temporary editing state
class DraftService {
  static const String _draftKey = 'text_moment_draft';

  final AppDatabase _database = AppDatabase.instance;

  // In-memory temporary editing state (not persisted)
  static DraftData? _editingTempData;

  /// Save draft to keyValues table
  Future<void> saveDraft({
    required String content,
    List<String>? moods,
    List<DraftMediaData>? mediaAttachments,
  }) async {
    try {
      final draftData = DraftData(
        content: content.trim(),
        moods: moods ?? [],
        mediaAttachments: mediaAttachments ?? [],
        lastModified: DateTime.now(),
      );

      if (!draftData.hasContent) {
        // Clear draft if no content
        await clearDraft();
        return;
      }

      final jsonString = jsonEncode(draftData.toJson());
      await _database.setValue(_draftKey, jsonString);

      AppLogger.info(
        'Saved text moment draft: ${content.length} chars, moods: ${moods?.join(", ") ?? "none"}, media: ${mediaAttachments?.length ?? 0}',
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
        'Loaded text moment draft: ${draft.content.length} chars, moods: ${draft.moods.join(", ")}, media: ${draft.mediaAttachments.length}',
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
      return draft != null && draft.hasContent;
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

  void autoSaveDraft({
    required String content,
    List<String>? moods,
    List<DraftMediaData>? mediaAttachments,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_autoSaveDelay, () {
      saveDraft(
        content: content,
        moods: moods,
        mediaAttachments: mediaAttachments,
      );
    });
  }

  /// Cancel any pending auto-save
  void cancelAutoSave() {
    _debounceTimer?.cancel();
  }

  /// Add media to current draft
  Future<void> addMediaToDraft(DraftMediaData media) async {
    try {
      final currentDraft = await loadDraft();
      final mediaList = List<DraftMediaData>.from(
        currentDraft?.mediaAttachments ?? [],
      );
      mediaList.add(media);

      await saveDraft(
        content: currentDraft?.content ?? '',
        moods: currentDraft?.moods,
        mediaAttachments: mediaList,
      );

      AppLogger.info(
        'Added media to draft: ${media.mediaType.name} - ${media.filePath}',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add media to draft', e, stackTrace);
    }
  }

  /// Add multiple media files to current draft
  Future<void> addMultipleMediaToDraft(List<DraftMediaData> mediaList) async {
    try {
      final currentDraft = await loadDraft();
      final existingMedia = List<DraftMediaData>.from(
        currentDraft?.mediaAttachments ?? [],
      );
      existingMedia.addAll(mediaList);

      await saveDraft(
        content: currentDraft?.content ?? '',
        moods: currentDraft?.moods,
        mediaAttachments: existingMedia,
      );

      AppLogger.info('Added ${mediaList.length} media files to draft');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add multiple media to draft', e, stackTrace);
    }
  }

  /// Remove media from draft
  Future<void> removeMediaFromDraft(String filePath) async {
    try {
      final currentDraft = await loadDraft();
      if (currentDraft == null) return;

      final mediaList = currentDraft.mediaAttachments
          .where((media) => media.filePath != filePath)
          .toList();

      await saveDraft(
        content: currentDraft.content,
        moods: currentDraft.moods,
        mediaAttachments: mediaList,
      );

      AppLogger.info('Removed media from draft: $filePath');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to remove media from draft', e, stackTrace);
    }
  }

  // === In-memory temporary editing state methods for editing existing moments ===

  /// Save temporary editing state (in memory, for editing existing moments)
  void saveEditingTemp({
    required String content,
    List<String>? moods,
    List<DraftMediaData>? mediaAttachments,
  }) {
    try {
      _editingTempData = DraftData(
        content: content.trim(),
        moods: moods ?? [],
        mediaAttachments: mediaAttachments ?? [],
        lastModified: DateTime.now(),
      );

      AppLogger.info(
        'Saved editing temp state: ${content.length} chars, moods: ${moods?.join(", ") ?? "none"}, media: ${mediaAttachments?.length ?? 0}',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save editing temp state', e, stackTrace);
    }
  }

  /// Load temporary editing state (from memory)
  DraftData? loadEditingTemp() {
    try {
      if (_editingTempData != null) {
        AppLogger.info(
          'Loaded editing temp state: ${_editingTempData!.content.length} chars, moods: ${_editingTempData!.moods.join(", ")}, media: ${_editingTempData!.mediaAttachments.length}',
        );
      }
      return _editingTempData;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load editing temp state', e, stackTrace);
      return null;
    }
  }

  /// Clear temporary editing state (from memory)
  void clearEditingTemp() {
    try {
      _editingTempData = null;
      AppLogger.info('Cleared editing temp state');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear editing temp state', e, stackTrace);
    }
  }

  /// Check if there's unsaved editing temp data
  bool hasUnsavedEditingTemp() {
    return _editingTempData != null && _editingTempData!.hasContent;
  }

  /// Add media to temporary editing state (in memory)
  void addMediaToEditingTemp(DraftMediaData media) {
    try {
      final currentTemp = loadEditingTemp();
      final mediaList = List<DraftMediaData>.from(
        currentTemp?.mediaAttachments ?? [],
      );
      mediaList.add(media);

      saveEditingTemp(
        content: currentTemp?.content ?? '',
        moods: currentTemp?.moods,
        mediaAttachments: mediaList,
      );

      AppLogger.info(
        'Added media to editing temp: ${media.mediaType.name} - ${media.filePath}',
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to add media to editing temp', e, stackTrace);
    }
  }

  /// Add multiple media files to temporary editing state (in memory)
  void addMultipleMediaToEditingTemp(List<DraftMediaData> mediaList) {
    try {
      final currentTemp = loadEditingTemp();
      final existingMedia = List<DraftMediaData>.from(
        currentTemp?.mediaAttachments ?? [],
      );
      existingMedia.addAll(mediaList);

      saveEditingTemp(
        content: currentTemp?.content ?? '',
        moods: currentTemp?.moods,
        mediaAttachments: existingMedia,
      );

      AppLogger.info('Added ${mediaList.length} media files to editing temp');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to add multiple media to editing temp',
        e,
        stackTrace,
      );
    }
  }
}
