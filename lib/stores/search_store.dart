import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../databases/app_database.dart';
import '../models/moment.dart';
import '../utils/app_logger.dart';

/// Store for managing search functionality
class SearchStore extends ChangeNotifier {
  final AppDatabase _database = AppDatabase.instance;

  List<MomentData> _searchResults = [];
  String _currentQuery = '';
  bool _isSearching = false;
  String? _error;
  List<String> _recentSearches = [];

  // Search filters
  List<ContentType> _contentTypeFilters = [];
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _moodFilters = [];

  // Getters
  List<MomentData> get searchResults => _searchResults;
  String get currentQuery => _currentQuery;
  bool get isSearching => _isSearching;
  String? get error => _error;
  List<String> get recentSearches => _recentSearches;
  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasActiveFilters =>
      _contentTypeFilters.isNotEmpty ||
      _startDate != null ||
      _endDate != null ||
      _moodFilters.isNotEmpty;

  // Filter getters
  List<ContentType> get contentTypeFilters => _contentTypeFilters;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<String> get moodFilters => _moodFilters;

  /// Perform search with current query and filters
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _currentQuery = query.trim();
    _setSearching(true);
    _clearError();

    try {
      AppLogger.userAction('Searching moments', {
        'query': _currentQuery,
        'contentTypeFilters': _contentTypeFilters.map((e) => e.name).toList(),
        'startDate': _startDate?.toIso8601String(),
        'endDate': _endDate?.toIso8601String(),
        'moodFilters': _moodFilters,
      });

      // Get all moments first (in a real app, this would be optimized with database queries)
      final allMoments = await _database.getAllMoments();

      // Apply text search
      List<MomentData> results = _performTextSearch(allMoments, _currentQuery);

      // Apply filters
      results = _applyFilters(results);

      // Sort results by relevance and recency
      results = _sortResults(results, _currentQuery);

      _searchResults = results;
      _addToRecentSearches(_currentQuery);

      AppLogger.info(
        'Search completed: found ${_searchResults.length} results',
      );
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.error('Search failed', e, stackTrace);
      _setError('Search failed: $e');
    } finally {
      _setSearching(false);
    }
  }

  /// Clear search results and query
  void clearSearch() {
    _searchResults.clear();
    _currentQuery = '';
    _clearError();
    AppLogger.userAction('Search cleared');
    notifyListeners();
  }

  /// Set content type filters
  void setContentTypeFilters(List<ContentType> types) {
    _contentTypeFilters = types;
    AppLogger.userAction('Content type filters updated', {
      'filters': types.map((e) => e.name).toList(),
    });
    if (_currentQuery.isNotEmpty) {
      search(_currentQuery); // Re-search with new filters
    }
  }

  /// Set date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    AppLogger.userAction('Date range filter updated', {
      'startDate': start?.toIso8601String(),
      'endDate': end?.toIso8601String(),
    });
    if (_currentQuery.isNotEmpty) {
      search(_currentQuery); // Re-search with new filters
    }
  }

  /// Set mood filters
  void setMoodFilters(List<String> moods) {
    _moodFilters = moods;
    AppLogger.userAction('Mood filters updated', {'filters': moods});
    if (_currentQuery.isNotEmpty) {
      search(_currentQuery); // Re-search with new filters
    }
  }

  /// Clear all filters
  void clearFilters() {
    _contentTypeFilters.clear();
    _startDate = null;
    _endDate = null;
    _moodFilters.clear();
    AppLogger.userAction('All filters cleared');
    if (_currentQuery.isNotEmpty) {
      search(_currentQuery); // Re-search without filters
    }
  }

  /// Add search to recent searches
  void _addToRecentSearches(String query) {
    if (_recentSearches.contains(query)) {
      _recentSearches.remove(query);
    }
    _recentSearches.insert(0, query);

    // Keep only last 10 searches
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }
  }

  /// Clear recent searches
  void clearRecentSearches() {
    _recentSearches.clear();
    AppLogger.userAction('Recent searches cleared');
    notifyListeners();
  }

  /// Get search suggestions based on query
  List<String> getSearchSuggestions(String query) {
    if (query.isEmpty) return _recentSearches;

    final lowerQuery = query.toLowerCase();
    return _recentSearches
        .where((search) => search.toLowerCase().contains(lowerQuery))
        .take(5)
        .toList();
  }

  // Private helper methods
  List<MomentData> _performTextSearch(List<MomentData> moments, String query) {
    final lowerQuery = query.toLowerCase();
    return moments.where((moment) {
      final moodsList = _parseMoodsFromJson(moment.moods);
      final moodsContainQuery = moodsList.any(
        (mood) => mood.toLowerCase().contains(lowerQuery),
      );
      return moment.content.toLowerCase().contains(lowerQuery) ||
          moodsContainQuery;
    }).toList();
  }

  List<MomentData> _applyFilters(List<MomentData> moments) {
    List<MomentData> filtered = moments;

    // Content type filter
    if (_contentTypeFilters.isNotEmpty) {
      filtered = filtered
          .where((moment) => _contentTypeFilters.contains(moment.contentType))
          .toList();
    }

    // Date range filter
    if (_startDate != null) {
      filtered = filtered
          .where((moment) => moment.createdAt.isAfter(_startDate!))
          .toList();
    }
    if (_endDate != null) {
      final endOfDay = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        23,
        59,
        59,
      );
      filtered = filtered
          .where((moment) => moment.createdAt.isBefore(endOfDay))
          .toList();
    }

    // Mood filter
    if (_moodFilters.isNotEmpty) {
      filtered = filtered.where((moment) {
        final moodsList = _parseMoodsFromJson(moment.moods);
        return moodsList.any((mood) => _moodFilters.contains(mood));
      }).toList();
    }

    return filtered;
  }

  List<MomentData> _sortResults(List<MomentData> moments, String query) {
    // Simple sorting: exact matches first, then by recency
    moments.sort((a, b) {
      final aExactMatch = a.content.toLowerCase().contains(query.toLowerCase());
      final bExactMatch = b.content.toLowerCase().contains(query.toLowerCase());

      if (aExactMatch && !bExactMatch) return -1;
      if (!aExactMatch && bExactMatch) return 1;

      // Both have same match level, sort by recency
      return b.createdAt.compareTo(a.createdAt);
    });

    return moments;
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
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

  @override
  void dispose() {
    AppLogger.debug('SearchStore disposed');
    super.dispose();
  }
}
