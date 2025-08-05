import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/premium_button/premium_button.dart';
import '../../themes/app_colors.dart';
import '../../stores/moment_store.dart';
import '../../utils/app_logger.dart';

/// Advanced filter dropdown for timeline with search, date, and tag filters
class TimelineFilterDropdown extends StatefulWidget {
  final VoidCallback onClose;
  final List<String> availableTags;

  const TimelineFilterDropdown({
    super.key,
    required this.onClose,
    required this.availableTags,
  });

  @override
  State<TimelineFilterDropdown> createState() => _TimelineFilterDropdownState();
}

class _TimelineFilterDropdownState extends State<TimelineFilterDropdown>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late TextEditingController _tagController;
  late FocusNode _searchFocusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Filter state
  String _searchQuery = '';
  List<String> _selectedTags = [];
  DateTimeRange? _selectedDateRange;

  // Date filter presets
  final List<_DatePreset> _datePresets = [
    _DatePreset('Today', _getToday()),
    _DatePreset('This Week', _getThisWeek()),
    _DatePreset('This Month', _getThisMonth()),
    _DatePreset('Last 7 Days', _getLast7Days()),
    _DatePreset('Last 30 Days', _getLast30Days()),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tagController = TextEditingController();
    _searchFocusNode = FocusNode();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Load current filters from moment store
    final momentStore = context.read<MomentStore>();
    _searchQuery = momentStore.filter.searchQuery ?? '';
    _selectedTags = List.from(momentStore.filter.selectedTags ?? []);
    _selectedDateRange = momentStore.filter.selectedDateRange;
    _searchController.text = _searchQuery;

    // Start entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tagController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Static date range getters
  static DateTimeRange _getToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: today, end: today.add(const Duration(days: 1)));
  }

  static DateTimeRange _getThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return DateTimeRange(start: start, end: start.add(const Duration(days: 7)));
  }

  static DateTimeRange _getThisMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);
    return DateTimeRange(start: monthStart, end: monthEnd);
  }

  static DateTimeRange _getLast7Days() {
    final now = DateTime.now();
    final end = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    final start = end.subtract(const Duration(days: 7));
    return DateTimeRange(start: start, end: end);
  }

  static DateTimeRange _getLast30Days() {
    final now = DateTime.now();
    final end = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1));
    final start = end.subtract(const Duration(days: 30));
    return DateTimeRange(start: start, end: end);
  }

  void _applyFilters() {
    final momentStore = context.read<MomentStore>();

    // Apply all filters
    momentStore.filter.applyMultipleFilters(
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
      tags: _selectedTags.isNotEmpty ? _selectedTags : null,
      dateRange: _selectedDateRange,
    );

    AppLogger.userAction('Timeline filters applied', {
      'searchQuery': _searchQuery,
      'selectedTags': _selectedTags,
      'dateRange': _selectedDateRange?.toString(),
    });

    widget.onClose();
  }

  void _clearAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedTags.clear();
      _selectedDateRange = null;
      _searchController.clear();
    });

    AppLogger.userAction('Timeline filters cleared');
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedTags.isNotEmpty ||
      _selectedDateRange != null;

  bool get _isPresetSelected {
    if (_selectedDateRange == null) return false;

    return _datePresets.any(
      (preset) =>
          preset.range.start == _selectedDateRange!.start &&
          preset.range.end == _selectedDateRange!.end,
    );
  }

  String _formatDateRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end.subtract(
      const Duration(days: 1),
    ); // Adjust for inclusive range

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return '${start.month}/${start.day}';
    }

    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }

  Future<void> _showCustomDatePicker() async {
    final initialDateRange =
        _selectedDateRange ??
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        );

    final dateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              onPrimary: Colors.white,
              surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              onSurface: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dateRange != null) {
      setState(() {
        _selectedDateRange = DateTimeRange(
          start: dateRange.start,
          end: dateRange.end.add(const Duration(days: 1)), // Make end inclusive
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Center(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                margin: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.vertical -
                      150,
                ),
                child: Stack(
                  children: [
                    // Main content
                    PremiumGlassCard(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      borderRadius: 24,
                      hasGradient: true,
                      elevation: 20,
                      gradientColors: isDark
                          ? [
                              AppColors.darkSurface.withValues(alpha: 0.95),
                              AppColors.darkSurface.withValues(alpha: 0.85),
                            ]
                          : [
                              AppColors.lightSurface.withValues(alpha: 0.98),
                              AppColors.lightSurface.withValues(alpha: 0.92),
                            ],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrollable content
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Search Section
                                  _buildSearchSection(theme, isDark),
                                  const SizedBox(height: 24),

                                  // Date Filter Section
                                  _buildDateFilterSection(theme, isDark),
                                  const SizedBox(height: 24),

                                  // Tag Filter Section
                                  _buildTagFilterSection(theme, isDark),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),

                          // Action Buttons (fixed at bottom)
                          _buildActionButtons(theme, isDark),
                        ],
                      ),
                    ),
                    // Close button positioned absolutely
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: widget.onClose,
                        child: Icon(
                          Icons.close_rounded,
                          size: 24,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.3)
                : AppColors.lightSurface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.2,
              ),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Leading icon
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.search_rounded,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  size: 24,
                ),
              ),

              // Search input
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search your diary moments...',
                      hintStyle: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                      hoverColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),

              // Clear button
              if (_searchQuery.isNotEmpty) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.clear_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilterSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Date Filter',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            if (_selectedDateRange != null)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _selectedDateRange = null;
                  });
                },
                child: Text(
                  'Clear',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.lightAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._datePresets.map((preset) {
              final isSelected =
                  _selectedDateRange != null &&
                  _selectedDateRange!.start == preset.range.start &&
                  _selectedDateRange!.end == preset.range.end;
              return _FilterChip(
                label: preset.label,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    _selectedDateRange = isSelected ? null : preset.range;
                  });
                },
              );
            }),
            // Custom date range option
            _FilterChip(
              label: _selectedDateRange != null && !_isPresetSelected
                  ? 'Custom (${_formatDateRange(_selectedDateRange!)})'
                  : 'Custom',
              isSelected: _selectedDateRange != null && !_isPresetSelected,
              isDark: isDark,
              onTap: _showCustomDatePicker,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTagFilterSection(ThemeData theme, bool isDark) {
    // All available tags including existing and custom ones
    final allTags = <String>{
      ...widget.availableTags,
      ..._selectedTags,
    }.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tags',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            if (_selectedTags.isNotEmpty)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    _selectedTags.clear();
                  });
                },
                child: Text(
                  'Clear',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.lightAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Add custom tag input
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface.withValues(alpha: 0.3)
                : AppColors.lightSurface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.2,
              ),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Leading icon
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.add_rounded,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  size: 20,
                ),
              ),

              // Tag input
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _tagController,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Add custom tag...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                      hoverColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty &&
                          !_selectedTags.contains(value.trim())) {
                        setState(() {
                          _selectedTags.add(value.trim());
                        });
                        _tagController.clear();
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),
            ],
          ),
        ),

        // Existing and selected tags
        if (allTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return _FilterChip(
                label: '#$tag',
                isSelected: isSelected,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),

        // Show message when no tags available
        if (allTags.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No tags available. Add a custom tag above.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Row(
      children: [
        // Clear All button
        if (_hasActiveFilters)
          Expanded(
            child: PremiumButton(
              text: 'Clear All',
              onPressed: _clearAllFilters,
              isOutlined: true,
              borderRadius: 16,
            ),
          ),
        if (_hasActiveFilters) const SizedBox(width: 12),

        // Apply button
        Expanded(
          child: PremiumButton(
            text: 'Apply Filters',
            onPressed: _applyFilters,
            isOutlined: false,
            borderRadius: 16,
            hasGradient: true,
          ),
        ),
      ],
    );
  }
}

/// Date preset helper class
class _DatePreset {
  final String label;
  final DateTimeRange range;

  const _DatePreset(this.label, this.range);
}

/// Reusable filter chip component with smooth animations
class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: widget.isSelected
              ? LinearGradient(
                  colors: AppColors.getPrimaryGradient(widget.isDark),
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isSelected
                ? Colors.transparent
                : (widget.isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1)),
            width: 1,
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          style:
              theme.textTheme.bodyMedium?.copyWith(
                color: widget.isSelected
                    ? Colors.white
                    : (widget.isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                fontWeight: FontWeight.w500,
              ) ??
              const TextStyle(),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
