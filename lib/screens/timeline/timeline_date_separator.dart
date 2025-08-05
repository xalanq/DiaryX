part of 'timeline_screen.dart';

/// Sticky date separator delegate
class _StickyDateSeparatorDelegate extends SliverPersistentHeaderDelegate {
  final String dateLabel;
  final int momentCount;
  final VoidCallback onCalendarTap;
  final String? selectedTagFilter;
  final VoidCallback? onClearFilter;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  _StickyDateSeparatorDelegate({
    required this.dateLabel,
    required this.momentCount,
    required this.onCalendarTap,
    this.selectedTagFilter,
    this.onClearFilter,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  double get minExtent => _StickyDateSeparatorCard.dateSeparatorHeight;

  @override
  double get maxExtent => _StickyDateSeparatorCard.dateSeparatorHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _StickyDateSeparatorCard(
      dateLabel: dateLabel,
      momentCount: momentCount,
      onCalendarTap: onCalendarTap,
      selectedTagFilter: selectedTagFilter,
      onClearFilter: onClearFilter,
      onFilterTap: onFilterTap,
      hasActiveFilters: hasActiveFilters,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is! _StickyDateSeparatorDelegate ||
        oldDelegate.dateLabel != dateLabel ||
        oldDelegate.momentCount != momentCount ||
        oldDelegate.onCalendarTap != onCalendarTap ||
        oldDelegate.selectedTagFilter != selectedTagFilter ||
        oldDelegate.onClearFilter != onClearFilter ||
        oldDelegate.onFilterTap != onFilterTap ||
        oldDelegate.hasActiveFilters != hasActiveFilters;
  }
}

class _StickyDateSeparatorCard extends StatelessWidget {
  static const dateSeparatorHeight = 100.0;

  final String dateLabel;
  final int momentCount;
  final VoidCallback onCalendarTap;
  final String? selectedTagFilter;
  final VoidCallback? onClearFilter;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const _StickyDateSeparatorCard({
    required this.dateLabel,
    required this.momentCount,
    required this.onCalendarTap,
    this.selectedTagFilter,
    this.onClearFilter,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: dateSeparatorHeight,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          PremiumGlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            borderRadius: 24,
            hasGradient: true,
            gradientColors: isDark
                ? [
                    AppColors.darkSurface.withValues(alpha: 0.9),
                    AppColors.darkSurface.withValues(alpha: 0.7),
                  ]
                : [
                    AppColors.lightSurface.withValues(alpha: 0.95),
                    AppColors.lightSurface.withValues(alpha: 0.85),
                  ],
            child: Row(
              children: [
                // Elegant icon container with gradient styling
                GestureDetector(
                  onTap: onCalendarTap,
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.2),
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.today_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Date information display
                Expanded(
                  child: GestureDetector(
                    onTap: onCalendarTap,
                    child: Text(
                      dateLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // Filter button (left of moment count) - plain icon
                if (onFilterTap != null) ...[
                  GestureDetector(
                    onTap: onFilterTap,
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: BoxBorder.all(
                          color: hasActiveFilters
                              ? isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary
                              : Colors.transparent,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        size: 22,
                        color: hasActiveFilters
                            ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                            : (isDark
                                  ? AppColors.darkTextSecondary
                                  : const Color(0xFFBCBCBC)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Show selected tag filter if active (right side)
                if (selectedTagFilter != null) ...[
                  GestureDetector(
                    onTap: onClearFilter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.3),
                            (isDark
                                    ? AppColors.darkAccent
                                    : AppColors.lightAccent)
                                .withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.filter_alt,
                            size: 16,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '#$selectedTagFilter',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.close_rounded,
                            size: 16,
                            color:
                                (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary)
                                    .withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Count badge (only show if momentCount > 0)
                if (momentCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '$momentCount',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
