part of 'report_screen.dart';

/// Premium AI Analysis section
class _PremiumAIAnalysisSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 20,
      hasGradient: true,
      gradientColors: isDark
          ? [
              AppColors.darkSurface.withValues(alpha: 0.9),
              AppColors.darkSurface.withValues(alpha: 0.6),
            ]
          : [
              AppColors.lightSurface.withValues(alpha: 0.95),
              AppColors.lightSurface.withValues(alpha: 0.8),
            ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AppLogger.userAction('AI Analysis tapped');
            _showComingSoon(context);
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
                      Row(
                        children: [
                          Text(
                            'AI Analysis',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                              'Phase 8',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Get AI-powered insights about your\njournaling patterns and emotional growth',
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

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Analysis'),
        content: const Text(
          'AI-powered analysis will be available in future updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Premium analytics section
class _PremiumAnalyticsSection extends StatelessWidget {
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

        // Chart placeholders
        _PremiumChartCard(
          title: 'Mood Trends',
          description: 'Track your emotional journey\nover time',
          icon: Icons.trending_up_rounded,
          height: 180,
          phaseLabel: 'Phase 8',
        ),
        const SizedBox(height: 16),

        _PremiumChartCard(
          title: 'Writing Frequency',
          description: 'Your journaling activity\npatterns and consistency',
          icon: Icons.edit_calendar_rounded,
          height: 140,
          phaseLabel: 'Phase 8',
        ),
        const SizedBox(height: 16),

        _PremiumChartCard(
          title: 'Content Insights',
          description: 'Word clouds and topic\nanalysis over time',
          icon: Icons.cloud_rounded,
          height: 160,
          phaseLabel: 'Phase 9',
        ),
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
              hasGradient: true,
              gradientColors: isDark
                  ? [
                      AppColors.darkSurface.withValues(alpha: 0.8),
                      AppColors.darkSurface.withValues(alpha: 0.4),
                    ]
                  : [
                      AppColors.lightSurface.withValues(alpha: 0.9),
                      AppColors.lightSurface.withValues(alpha: 0.6),
                    ],
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
