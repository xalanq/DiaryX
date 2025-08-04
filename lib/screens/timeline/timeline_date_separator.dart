part of 'timeline_screen.dart';

const _dateSeparatorHeight = 100.0;

/// Sticky date separator delegate
class _StickyDateSeparatorDelegate extends SliverPersistentHeaderDelegate {
  final String dateLabel;
  final int momentCount;
  final VoidCallback onCalendarTap;

  _StickyDateSeparatorDelegate({
    required this.dateLabel,
    required this.momentCount,
    required this.onCalendarTap,
  });

  @override
  double get minExtent => _dateSeparatorHeight;

  @override
  double get maxExtent => _dateSeparatorHeight;

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
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is! _StickyDateSeparatorDelegate ||
        oldDelegate.dateLabel != dateLabel ||
        oldDelegate.momentCount != momentCount ||
        oldDelegate.onCalendarTap != onCalendarTap;
  }
}

class _StickyDateSeparatorCard extends StatelessWidget {
  final String dateLabel;
  final int momentCount;
  final VoidCallback onCalendarTap;

  const _StickyDateSeparatorCard({
    required this.dateLabel,
    required this.momentCount,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: _dateSeparatorHeight,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                  child: Text(
                    dateLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ),

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
