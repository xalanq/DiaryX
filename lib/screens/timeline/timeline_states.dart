part of 'timeline_screen.dart';

/// Loading state for premium timeline display
class _PremiumTimelineLoadingState extends StatelessWidget {
  const _PremiumTimelineLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: FadeInSlideUp(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading moments...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Premium empty state when no moments exist
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
                bottom: 20,
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
