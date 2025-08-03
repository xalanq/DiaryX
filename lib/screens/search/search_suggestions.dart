part of 'search_screen.dart';

/// Premium search suggestions
class _PremiumSearchSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationContainer(
      staggerDelay: const Duration(milliseconds: 100),
      children: [
        const SizedBox(height: 16),
        _PremiumRecentSearches(),
        const SizedBox(height: 20),
        _PremiumSearchTips(),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Premium recent searches section
class _PremiumRecentSearches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header similar to profile page
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Searches',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Card with content - similar to profile page
        PremiumGlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 28,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent searches',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your searches will appear here',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Premium search tips section
class _PremiumSearchTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header similar to profile page
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Search Tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Card with items - similar to profile page
        PremiumGlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _PremiumSearchTip(
                icon: Icons.text_fields_rounded,
                title: 'Search by content',
                description: 'Find moments containing specific words',
                color: Colors.blue,
              ),
              _buildDivider(isDark),
              _PremiumSearchTip(
                icon: Icons.mood_rounded,
                title: 'Search by mood',
                description: 'Filter moments by emotional state',
                color: Colors.green,
              ),
              _buildDivider(isDark),
              _PremiumSearchTip(
                icon: Icons.calendar_today_rounded,
                title: 'Search by date',
                description: 'Find moments from specific periods',
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      indent: 84, // 20 (card padding) + 44 (icon width) + 20 (gap)
      endIndent: 20,
      height: 1,
      color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
          .withValues(alpha: 0.2),
    );
  }
}

/// Premium search tip item
class _PremiumSearchTip extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _PremiumSearchTip({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          AppLogger.userAction('Search tip tapped', {'tip': title});
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withValues(alpha: 0.1),
        highlightColor: color.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            children: [
              // Enhanced icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron with subtle animation hint
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.05,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
