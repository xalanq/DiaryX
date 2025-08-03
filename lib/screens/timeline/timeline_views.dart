part of 'timeline_screen.dart';

class _PremiumTimelineLoadingState extends StatelessWidget {
  const _PremiumTimelineLoadingState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StaggeredAnimationContainer(
        children: List.generate(
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
      ),
    );
  }
}

/// Premium no moments state
class _PremiumNoMomentsState extends StatelessWidget {
  final VoidCallback onCreateMoment;

  const _PremiumNoMomentsState({required this.onCreateMoment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kBottomNavigationBarHeight -
              120, // AppBar and padding
        ),
        child: Center(
          child: FadeInSlideUp(
            child: Padding(
              padding: EdgeInsets.only(
                top: 40,
                bottom: 120,
                left: 20,
                right: 20,
              ),
              child: PremiumGlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No Moments Yet',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start your journaling journey by creating your first moment.',
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
                      text: 'Create Moment',
                      onPressed: onCreateMoment,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumListView extends StatelessWidget {
  final List<Moment> moments;

  const _PremiumListView({required this.moments});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        AppLogger.userAction('Timeline pull to refresh');
        await context.read<MomentStore>().loadMoments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100, top: 16), // Space for FAB
        itemCount: moments.length,
        itemBuilder: (context, index) {
          return FadeInSlideUp(
            delay: Duration(milliseconds: index * 100),
            child: _PremiumMomentListItem(moment: moments[index], index: index),
          );
        },
      ),
    );
  }
}

class _PremiumCalendarView extends StatelessWidget {
  final List<Moment> moments;

  const _PremiumCalendarView({required this.moments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Premium Calendar header
        Padding(
          padding: const EdgeInsets.all(20),
          child: PremiumGlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PremiumIconButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: () {
                    AppLogger.userAction('Calendar previous month');
                  },
                ),
                Text(
                  'January 2024', // TODO: Make dynamic
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                PremiumIconButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: () {
                    AppLogger.userAction('Calendar next month');
                  },
                ),
              ],
            ),
          ),
        ),

        // Premium Calendar placeholder with enhanced styling
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PremiumGlassCard(
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
              child: Center(
                child: FadeInSlideUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleInBounce(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                    .withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Calendar View',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Beautiful calendar interface coming soon',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PremiumPulseAnimation(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.getPrimaryGradient(isDark),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Phase 5',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
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
