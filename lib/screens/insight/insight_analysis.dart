part of 'insight_screen.dart';

/// Premium AI Analysis section
class _PremiumAIAnalysisSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppLogger.userAction('AI Analysis tapped');
            final navigationStore = Provider.of<NavigationStore>(
              context,
              listen: false,
            );
            navigationStore.switchToChat();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // AI Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Analysis',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Get AI-powered insights about your\njournaling patterns and mood growth',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium analytics section
class _PremiumAnalyticsSection extends StatefulWidget {
  const _PremiumAnalyticsSection({super.key});

  @override
  State<_PremiumAnalyticsSection> createState() =>
      _PremiumAnalyticsSectionState();
}

class _PremiumAnalyticsSectionState extends State<_PremiumAnalyticsSection> {
  // Global keys to access child chart components for data refresh
  final GlobalKey<_MoodTrendsCardState> _moodTrendsKey = GlobalKey();
  final GlobalKey<_WritingFrequencyCardState> _writingFrequencyKey =
      GlobalKey();
  final GlobalKey<_ContentDistributionCardState> _contentDistributionKey =
      GlobalKey();

  /// Public method to refresh all analytics data
  void _refreshData() {
    // Call refresh methods on all child chart components without rebuilding them
    _moodTrendsKey.currentState?.refreshData();
    _writingFrequencyKey.currentState?.refreshData();
    _contentDistributionKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.analytics_rounded,
                size: 20,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Insights into your journaling patterns',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.6,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Real chart implementations
        _MoodTrendsCard(key: _moodTrendsKey),
        const SizedBox(height: 16),

        _WritingFrequencyCard(key: _writingFrequencyKey),
        const SizedBox(height: 16),

        _ContentDistributionCard(key: _contentDistributionKey),
      ],
    );
  }
}

/// Premium chart card placeholder
class _PremiumChartCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final double height;
  final String phaseLabel;

  const _PremiumChartCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.height,
    required this.phaseLabel,
  });

  @override
  State<_PremiumChartCard> createState() => _PremiumChartCardState();
}

class _PremiumChartCardState extends State<_PremiumChartCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            child: PremiumGlassCard(
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chart header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.darkSecondary
                                      : AppColors.lightSecondary)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.icon,
                          size: 16,
                          color: isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Phase indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.getPrimaryGradient(isDark),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.phaseLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chart placeholder
                  Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                AppColors.darkSurface.withValues(alpha: 0.3),
                                AppColors.darkSurface.withValues(alpha: 0.1),
                              ]
                            : [
                                AppColors.lightSurface.withValues(alpha: 0.4),
                                AppColors.lightSurface.withValues(alpha: 0.2),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.icon,
                            size: 48,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Coming Soon',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.textTheme.titleMedium?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Beautiful charts await in ${widget.phaseLabel}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Mood trends chart card with real data
class _MoodTrendsCard extends StatefulWidget {
  const _MoodTrendsCard({super.key});

  @override
  State<_MoodTrendsCard> createState() => _MoodTrendsCardState();
}

class _MoodTrendsCardState extends State<_MoodTrendsCard> {
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  AnalyticsOverview? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analytics = await _analyticsService.getAnalyticsOverview();
      if (mounted) {
        setState(() {
          _analytics = analytics;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load mood trends data', e);
      if (mounted) {
        setState(() {
          _analytics = AnalyticsOverview.empty();
          _isLoading = false;
        });
      }
    }
  }

  /// Public method to refresh mood trends data from parent
  void refreshData() {
    _loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkSecondary
                      : AppColors.lightSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mood Trends',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Track your mood journey over time',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart content
          SizedBox(
            height: 180,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                    ),
                  )
                : MoodTrendChart(
                    trendData: _analytics?.moodTrends ?? [],
                    isDark: isDark,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Writing frequency chart card with real data
class _WritingFrequencyCard extends StatefulWidget {
  const _WritingFrequencyCard({super.key});

  @override
  State<_WritingFrequencyCard> createState() => _WritingFrequencyCardState();
}

class _WritingFrequencyCardState extends State<_WritingFrequencyCard> {
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  AnalyticsOverview? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analytics = await _analyticsService.getAnalyticsOverview();
      if (mounted) {
        setState(() {
          _analytics = analytics;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load writing frequency data', e);
      if (mounted) {
        setState(() {
          _analytics = AnalyticsOverview.empty();
          _isLoading = false;
        });
      }
    }
  }

  /// Public method to refresh writing frequency data from parent
  void refreshData() {
    _loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_calendar_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkSecondary
                      : AppColors.lightSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Writing Frequency',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your journaling activity patterns and consistency',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart content
          SizedBox(
            height: 140,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                    ),
                  )
                : WritingFrequencyChart(
                    frequencyData: _analytics?.writingFrequency ?? [],
                    isDark: isDark,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Content distribution chart card with real data
class _ContentDistributionCard extends StatefulWidget {
  const _ContentDistributionCard({super.key});

  @override
  State<_ContentDistributionCard> createState() =>
      _ContentDistributionCardState();
}

class _ContentDistributionCardState extends State<_ContentDistributionCard> {
  final AnalyticsService _analyticsService = AnalyticsService.instance;
  AnalyticsOverview? _analytics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final analytics = await _analyticsService.getAnalyticsOverview();
      if (mounted) {
        setState(() {
          _analytics = analytics;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Failed to load content distribution data', e);
      if (mounted) {
        setState(() {
          _analytics = AnalyticsOverview.empty();
          _isLoading = false;
        });
      }
    }
  }

  /// Public method to refresh content distribution data from parent
  void refreshData() {
    _loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.pie_chart_outline_rounded,
                  size: 16,
                  color: isDark
                      ? AppColors.darkSecondary
                      : AppColors.lightSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Distribution',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Types of content in your diary moments',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart content
          Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                      ),
                    ),
                  )
                : ContentDistributionChart(
                    distribution:
                        _analytics?.contentDistribution ??
                        const ContentDistribution(
                          textOnly: 0,
                          withImages: 0,
                          withAudio: 0,
                          withVideo: 0,
                          multimedia: 0,
                        ),
                    isDark: isDark,
                  ),
          ),
        ],
      ),
    );
  }
}
