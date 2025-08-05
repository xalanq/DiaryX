import 'package:flutter/material.dart';
import '../models/moment.dart';
import '../utils/app_logger.dart';

/// Filter manager for moment filtering operations
class MomentFilter extends ChangeNotifier {
  final VoidCallback? _onFilterChanged;

  // Filter state
  String? _selectedTagFilter;
  String? _searchQuery;
  List<String>? _selectedTags;
  DateTimeRange? _selectedDateRange;

  MomentFilter({VoidCallback? onFilterChanged})
    : _onFilterChanged = onFilterChanged;

  // Getters
  String? get selectedTagFilter => _selectedTagFilter;
  String? get searchQuery => _searchQuery;
  List<String>? get selectedTags => _selectedTags;
  DateTimeRange? get selectedDateRange => _selectedDateRange;

  bool get hasActiveFilter => _hasAnyFilter;
  bool get _hasAnyFilter =>
      _selectedTagFilter != null ||
      _searchQuery != null ||
      (_selectedTags != null && _selectedTags!.isNotEmpty) ||
      _selectedDateRange != null;

  /// Apply filter to a list of moments and return filtered result
  List<Moment> applyFilters(List<Moment> moments) {
    if (!_hasAnyFilter) {
      return moments;
    }

    var filteredMoments = List<Moment>.from(moments);

    // Apply search query filter
    if (_searchQuery != null && _searchQuery!.trim().isNotEmpty) {
      final lowerQuery = _searchQuery!.toLowerCase();
      filteredMoments = filteredMoments.where((moment) {
        final contentMatches = moment.content.toLowerCase().contains(
          lowerQuery,
        );
        final moodsMatch = moment.moods.any(
          (mood) => mood.toLowerCase().contains(lowerQuery),
        );
        final tagsMatch = moment.tags.any(
          (tag) => tag.toLowerCase().contains(lowerQuery),
        );
        return contentMatches || moodsMatch || tagsMatch;
      }).toList();
    }

    // Apply tag filters
    if (_selectedTags != null && _selectedTags!.isNotEmpty) {
      filteredMoments = filteredMoments.where((moment) {
        return _selectedTags!.any(
          (selectedTag) => moment.tags.contains(selectedTag),
        );
      }).toList();
    }

    // Apply date range filter
    if (_selectedDateRange != null) {
      filteredMoments = filteredMoments.where((moment) {
        final momentDate = DateTime(
          moment.createdAt.year,
          moment.createdAt.month,
          moment.createdAt.day,
        );
        final start = DateTime(
          _selectedDateRange!.start.year,
          _selectedDateRange!.start.month,
          _selectedDateRange!.start.day,
        );
        final end = DateTime(
          _selectedDateRange!.end.year,
          _selectedDateRange!.end.month,
          _selectedDateRange!.end.day,
        );
        return momentDate.isAtSameMomentAs(start) ||
            momentDate.isAtSameMomentAs(end) ||
            (momentDate.isAfter(start) && momentDate.isBefore(end));
      }).toList();
    }

    // Apply legacy tag filter for backward compatibility
    if (_selectedTagFilter != null) {
      filteredMoments = filteredMoments
          .where(
            (moment) => moment.tags.any((tag) => tag == _selectedTagFilter),
          )
          .toList();
    }

    AppLogger.info(
      'Applied filters: ${filteredMoments.length}/${moments.length} moments',
    );

    return filteredMoments;
  }

  /// Filter moments by tag (legacy method for backward compatibility)
  void filterByTag(String tagName) {
    _selectedTagFilter = tagName;
    AppLogger.userAction('Filtered moments by tag', {'tagName': tagName});
    _notifyChange();
  }

  /// Apply multiple filters at once
  void applyMultipleFilters({
    String? searchQuery,
    List<String>? tags,
    DateTimeRange? dateRange,
  }) {
    _searchQuery = searchQuery;
    _selectedTags = tags;
    _selectedDateRange = dateRange;
    _selectedTagFilter = null; // Clear legacy filter

    AppLogger.userAction('Applied multiple filters', {
      'searchQuery': searchQuery,
      'tags': tags,
      'dateRange': dateRange?.toString(),
    });
    _notifyChange();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedTagFilter = null;
    _searchQuery = null;
    _selectedTags = null;
    _selectedDateRange = null;
    AppLogger.userAction('Cleared all moment filters');
    _notifyChange();
  }

  /// Get all unique tags from moments
  List<String> getAllTags(List<Moment> moments) {
    final tagSet = <String>{};
    for (final moment in moments) {
      tagSet.addAll(moment.tags);
    }
    return tagSet.toList()..sort();
  }

  /// Search moments by content (utility method)
  List<Moment> searchMoments(List<Moment> moments, String query) {
    if (query.trim().isEmpty) return moments;

    final lowerQuery = query.toLowerCase();
    return moments.where((moment) {
      final moodsContainQuery = moment.moods.any(
        (mood) => mood.toLowerCase().contains(lowerQuery),
      );
      return moment.content.toLowerCase().contains(lowerQuery) ||
          moodsContainQuery;
    }).toList();
  }

  /// Notify changes to both listeners and parent store
  void _notifyChange() {
    notifyListeners();
    _onFilterChanged?.call();
  }

  @override
  void dispose() {
    AppLogger.debug('MomentFilter disposed');
    super.dispose();
  }
}
