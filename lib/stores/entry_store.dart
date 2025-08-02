import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../services/database/database_service.dart';
import '../models/entry.dart';
import '../utils/app_logger.dart';

/// Store for managing diary entries state
class EntryStore extends ChangeNotifier {
  final AppDatabase _database = AppDatabase.instance;

  List<EntryData> _entries = [];
  bool _isLoading = false;
  String? _error;
  EntryData? _selectedEntry;

  // Getters
  List<EntryData> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;
  EntryData? get selectedEntry => _selectedEntry;
  bool get hasEntries => _entries.isNotEmpty;

  /// Load all entries from database
  Future<void> loadEntries() async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading entries from database');
      final entriesData = await _database.getAllEntries();
      _entries = entriesData;
      AppLogger.info('Loaded ${_entries.length} entries');
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load entries', e, stackTrace);
      _setError('Failed to load entries: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new entry
  Future<bool> createEntry({
    required String content,
    required ContentType contentType,
    String? mood,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Creating new entry', {
        'contentType': contentType.name,
        'mood': mood,
        'contentLength': content.length,
      });

      final now = DateTime.now();
      final companion = EntriesCompanion.insert(
        content: content,
        contentType: contentType,
        mood: Value(mood),
        createdAt: now,
        updatedAt: now,
        aiProcessed: const Value(false),
      );

      final entryId = await _database.into(_database.entries).insert(companion);
      final createdEntry = await _database.getEntryById(entryId);

      if (createdEntry != null) {
        _entries.insert(0, createdEntry); // Add to beginning of list
      }
      notifyListeners();

      AppLogger.info('Created entry with ID: $entryId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create entry', e, stackTrace);
      _setError('Failed to create entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing entry
  Future<bool> updateEntry(EntryData entry) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Updating entry', {'entryId': entry.id});

      final updatedEntry = entry.copyWith(updatedAt: DateTime.now());
      final success = await _database.updateEntry(updatedEntry);

      if (success) {
        final index = _entries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          _entries[index] = updatedEntry;
          notifyListeners();
        }
        AppLogger.info('Updated entry with ID: ${entry.id}');
        return true;
      } else {
        _setError('Failed to update entry');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update entry', e, stackTrace);
      _setError('Failed to update entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete an entry
  Future<bool> deleteEntry(int entryId) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Deleting entry', {'entryId': entryId});

      final deletedCount = await _database.deleteEntry(entryId);

      if (deletedCount > 0) {
        _entries.removeWhere((entry) => entry.id == entryId);
        if (_selectedEntry?.id == entryId) {
          _selectedEntry = null;
        }
        notifyListeners();
        AppLogger.info('Deleted entry with ID: $entryId');
        return true;
      } else {
        _setError('Entry not found');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete entry', e, stackTrace);
      _setError('Failed to delete entry: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Select an entry for viewing/editing
  void selectEntry(EntryData? entry) {
    _selectedEntry = entry;
    AppLogger.userAction('Selected entry', {'entryId': entry?.id});
    notifyListeners();
  }

  /// Get entries by content type
  List<EntryData> getEntriesByType(ContentType type) {
    return _entries.where((entry) => entry.contentType == type).toList();
  }

  /// Get entries by date range
  List<EntryData> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries.where((entry) {
      return entry.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
          entry.createdAt.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get entries by mood
  List<EntryData> getEntriesByMood(String mood) {
    return _entries.where((entry) => entry.mood == mood).toList();
  }

  /// Search entries by content
  List<EntryData> searchEntries(String query) {
    if (query.trim().isEmpty) return _entries;

    final lowerQuery = query.toLowerCase();
    return _entries.where((entry) {
      return entry.content.toLowerCase().contains(lowerQuery) ||
          (entry.mood?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get recent entries (last 7 days)
  List<EntryData> getRecentEntries({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _entries.where((entry) => entry.createdAt.isAfter(cutoffDate)).toList();
  }

  /// Clear all entries (for testing/reset)
  void clearEntries() {
    _entries.clear();
    _selectedEntry = null;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    AppLogger.debug('EntryStore disposed');
    super.dispose();
  }
}
