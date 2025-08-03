import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../databases/app_database.dart';
import '../models/moment.dart';
import '../utils/app_logger.dart';

/// Store for managing diary moments state
class MomentStore extends ChangeNotifier {
  final AppDatabase _database = AppDatabase.instance;

  List<MomentData> _moments = [];
  bool _isLoading = false;
  String? _error;
  MomentData? _selectedMoment;

  // Getters
  List<MomentData> get moments => _moments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  MomentData? get selectedMoment => _selectedMoment;
  bool get hasMoments => _moments.isNotEmpty;

  /// Load all moments from database
  Future<void> loadMoments() async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading moments from database');
      final momentsData = await _database.getAllMoments();
      _moments = momentsData;
      AppLogger.info('Loaded ${_moments.length} moments');
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load moments', e, stackTrace);
      _setError('Failed to load moments: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new moment
  Future<bool> createMoment({
    required String content,
    required ContentType contentType,
    List<String>? moods,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Creating new moment', {
        'contentType': contentType.name,
        'moods': moods,
        'contentLength': content.length,
      });

      final now = DateTime.now();
      final moodsJson = _convertMoodsToJson(moods);
      final companion = MomentsCompanion.insert(
        content: content,
        contentType: contentType,
        moods: Value(moodsJson),
        createdAt: now,
        updatedAt: now,
        aiProcessed: const Value(false),
      );

      final momentId = await _database
          .into(_database.moments)
          .insert(companion);
      final createdMoment = await _database.getMomentById(momentId);

      if (createdMoment != null) {
        _moments.insert(0, createdMoment); // Add to beginning of list
      }
      notifyListeners();

      AppLogger.info('Created moment with ID: $momentId');
      return true;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to create moment', e, stackTrace);
      _setError('Failed to create moment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing moment
  Future<bool> updateMoment(MomentData moment) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Updating moment', {'momentId': moment.id});

      final updatedMoment = moment.copyWith(updatedAt: DateTime.now());
      final success = await _database.updateMoment(updatedMoment);

      if (success) {
        final index = _moments.indexWhere((m) => m.id == moment.id);
        if (index != -1) {
          _moments[index] = updatedMoment;
          notifyListeners();
        }
        AppLogger.info('Updated moment with ID: ${moment.id}');
        return true;
      } else {
        _setError('Failed to update moment');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update moment', e, stackTrace);
      _setError('Failed to update moment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a moment
  Future<bool> deleteMoment(int momentId) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Deleting moment', {'momentId': momentId});

      final deletedCount = await _database.deleteMoment(momentId);

      if (deletedCount > 0) {
        _moments.removeWhere((moment) => moment.id == momentId);
        if (_selectedMoment?.id == momentId) {
          _selectedMoment = null;
        }
        notifyListeners();
        AppLogger.info('Deleted moment with ID: $momentId');
        return true;
      } else {
        _setError('Moment not found');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete moment', e, stackTrace);
      _setError('Failed to delete moment: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Select a moment for viewing/editing
  void selectMoment(MomentData? moment) {
    _selectedMoment = moment;
    AppLogger.userAction('Selected moment', {'momentId': moment?.id});
    notifyListeners();
  }

  /// Get moments by content type
  List<MomentData> getMomentsByType(ContentType type) {
    return _moments.where((moment) => moment.contentType == type).toList();
  }

  /// Get moments by date range
  List<MomentData> getMomentsByDateRange(DateTime start, DateTime end) {
    return _moments.where((moment) {
      return moment.createdAt.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          moment.createdAt.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get moments by mood
  List<MomentData> getMomentsByMood(String mood) {
    return _moments.where((moment) {
      final moodsList = _parseMoodsFromJson(moment.moods);
      return moodsList.contains(mood);
    }).toList();
  }

  /// Helper method to parse moods from JSON string
  List<String> _parseMoodsFromJson(String? moodsJson) {
    if (moodsJson == null || moodsJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(moodsJson);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      AppLogger.error('Failed to parse moods JSON: $moodsJson', e);
      return [];
    }
  }

  /// Helper method to convert moods list to JSON string
  String? _convertMoodsToJson(List<String>? moods) {
    if (moods == null || moods.isEmpty) return null;
    try {
      return jsonEncode(moods);
    } catch (e) {
      AppLogger.error('Failed to convert moods to JSON', e);
      return null;
    }
  }

  /// Search moments by content
  List<MomentData> searchMoments(String query) {
    if (query.trim().isEmpty) return _moments;

    final lowerQuery = query.toLowerCase();
    return _moments.where((moment) {
      final moodsList = _parseMoodsFromJson(moment.moods);
      final moodsContainQuery = moodsList.any(
        (mood) => mood.toLowerCase().contains(lowerQuery),
      );
      return moment.content.toLowerCase().contains(lowerQuery) ||
          moodsContainQuery;
    }).toList();
  }

  /// Get recent moments (last 7 days)
  List<MomentData> getRecentMoments({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _moments
        .where((moment) => moment.createdAt.isAfter(cutoffDate))
        .toList();
  }

  /// Clear all moments (for testing/reset)
  void clearMoments() {
    _moments.clear();
    _selectedMoment = null;
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
    AppLogger.debug('MomentStore disposed');
    super.dispose();
  }
}
