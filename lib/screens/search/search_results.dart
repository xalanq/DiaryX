part of 'search_screen.dart';

/// Premium search loading state
class _PremiumSearchLoadingState extends StatelessWidget {
  const _PremiumSearchLoadingState();

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationContainer(
      children: [
        const SizedBox(height: 16),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ShimmerLoading(
              child: PremiumGlassCard(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Premium no results state
class _PremiumNoResultsState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _PremiumNoResultsState({
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: FadeInSlideUp(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: PremiumGlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleInBounce(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 80,
                    height: 80,
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
                      size: 40,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No Results Found',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We couldn\'t find any moments matching\n"$searchQuery"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PremiumButton(
                  text: 'Clear Search',
                  onPressed: onClearSearch,
                  isOutlined: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium search results
class _PremiumSearchResults extends StatelessWidget {
  final List<dynamic> results;

  const _PremiumSearchResults({required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: results.asMap().entries.map((entry) {
          final index = entry.key;
          final result = entry.value;
          return FadeInSlideUp(
            delay: Duration(milliseconds: index * 100),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _PremiumSearchResultCard(result: result, index: index),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Premium search result card
class _PremiumSearchResultCard extends StatelessWidget {
  final dynamic result;
  final int index;

  const _PremiumSearchResultCard({required this.result, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      onTap: () {
        AppLogger.userAction('Search result tapped', {'index': index});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with metadata
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today, 2:30 PM', // TODO: Format actual date
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      size: 12,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Text',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content preview
          Text(
            'Search result content would appear here with highlighted keywords...',
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // Footer with tags and relevance
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                          .withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.1,
                    ),
                    width: 1,
                  ),
                ),
                child: Text(
                  '#sample',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.getPrimaryGradient(isDark),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '95% match',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
