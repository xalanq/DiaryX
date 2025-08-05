import 'package:flutter/foundation.dart';
import '../databases/app_database.dart';
import '../models/moment.dart';
import '../utils/app_logger.dart';

/// Store for managing diary moments state
class MomentStore extends ChangeNotifier {
  final AppDatabase _database = AppDatabase.instance;

  List<Moment> _moments = [];
  List<Moment> _filteredMoments = [];
  bool _isLoading = false;
  String? _error;
  Moment? _selectedMoment;
  String? _selectedTagFilter;

  // Getters
  List<Moment> get moments =>
      _selectedTagFilter != null ? _filteredMoments : _moments;
  List<Moment> get allMoments => _moments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Moment? get selectedMoment => _selectedMoment;
  bool get hasMoments => _moments.isNotEmpty;
  String? get selectedTagFilter => _selectedTagFilter;
  bool get hasActiveFilter => _selectedTagFilter != null;

  /// Load all moments from database
  Future<void> loadMoments() async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Loading moments from database');
      final momentsData = await _database.getAllMoments();

      // Convert MomentData to Moment using the conversion function
      final moments = <Moment>[];
      for (final momentData in momentsData) {
        final moment = await MomentExtensions.fromMomentData(
          momentData,
          _database,
        );
        moments.add(moment);
      }

      _moments = moments;
      _applyCurrentFilter();
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
  Future<bool> createMoment(Moment moment) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Creating new moment', {
        'moods': moment.moods,
        'contentLength': moment.content.length,
        'hasImages': moment.images.isNotEmpty,
        'hasAudios': moment.audios.isNotEmpty,
        'hasVideos': moment.videos.isNotEmpty,
      });

      // Use the Moment's save method which handles both moment and media
      final momentId = await moment.save(_database);

      // Load the created moment back to get the complete data
      final createdMomentData = await _database.getMomentById(momentId);
      if (createdMomentData != null) {
        final createdMoment = await MomentExtensions.fromMomentData(
          createdMomentData,
          _database,
        );
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
  Future<bool> updateMoment(Moment moment) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.userAction('Updating moment', {'momentId': moment.id});

      var updatedMoment = moment.copyWith(updatedAt: DateTime.now());
      final momentId = await updatedMoment.save(_database);
      final updatedMomentData = await _database.getMomentById(momentId);
      if (updatedMomentData == null) {
        _setError('Failed to update moment');
        return false;
      } else {
        updatedMoment = await MomentExtensions.fromMomentData(
          updatedMomentData,
          _database,
        );
      }

      if (momentId > 0) {
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
  void selectMoment(Moment? moment) {
    _selectedMoment = moment;
    AppLogger.userAction('Selected moment', {'momentId': moment?.id});
    notifyListeners();
  }

  /// Get moments by media type
  List<Moment> getMomentsByMediaType(String mediaType) {
    return _moments.where((moment) {
      switch (mediaType.toLowerCase()) {
        case 'text':
          return moment.content.isNotEmpty &&
              moment.images.isEmpty &&
              moment.audios.isEmpty &&
              moment.videos.isEmpty;
        case 'image':
          return moment.images.isNotEmpty;
        case 'audio':
          return moment.audios.isNotEmpty;
        case 'video':
          return moment.videos.isNotEmpty;
        case 'mixed':
          return (moment.images.isNotEmpty ? 1 : 0) +
                  (moment.audios.isNotEmpty ? 1 : 0) +
                  (moment.videos.isNotEmpty ? 1 : 0) >
              1;
        default:
          return false;
      }
    }).toList();
  }

  /// Get moments by date range
  List<Moment> getMomentsByDateRange(DateTime start, DateTime end) {
    return _moments.where((moment) {
      return moment.createdAt.isAfter(
            start.subtract(const Duration(days: 1)),
          ) &&
          moment.createdAt.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get moments by mood
  List<Moment> getMomentsByMood(String mood) {
    return _moments.where((moment) {
      return moment.moods.contains(mood);
    }).toList();
  }

  /// Search moments by content
  List<Moment> searchMoments(String query) {
    if (query.trim().isEmpty) return _moments;

    final lowerQuery = query.toLowerCase();
    return _moments.where((moment) {
      final moodsContainQuery = moment.moods.any(
        (mood) => mood.toLowerCase().contains(lowerQuery),
      );
      return moment.content.toLowerCase().contains(lowerQuery) ||
          moodsContainQuery;
    }).toList();
  }

  /// Get recent moments (last 7 days)
  List<Moment> getRecentMoments({int days = 7}) {
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

  /// Filter moments by tag
  void filterByTag(String tagName) {
    _selectedTagFilter = tagName;
    _applyCurrentFilter();
    AppLogger.userAction('Filtered moments by tag', {'tagName': tagName});
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedTagFilter = null;
    _filteredMoments.clear();
    AppLogger.userAction('Cleared moment filters');
    notifyListeners();
  }

  /// Apply current filter to moments
  void _applyCurrentFilter() {
    if (_selectedTagFilter == null) {
      _filteredMoments.clear();
      return;
    }

    _filteredMoments = _moments
        .where((moment) => moment.tags.any((tag) => tag == _selectedTagFilter))
        .toList();

    AppLogger.info(
      'Applied filter "$_selectedTagFilter": ${_filteredMoments.length}/${_moments.length} moments',
    );
  }

  @override
  void dispose() {
    AppLogger.debug('MomentStore disposed');
    super.dispose();
  }
}
