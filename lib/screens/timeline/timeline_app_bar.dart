part of 'timeline_screen.dart';

/// Premium app bar for timeline
class _PremiumTimelineAppBar extends StatelessWidget {
  final bool isCalendarMode;
  final VoidCallback onViewModeChanged;
  final VoidCallback onFilterPressed;

  const _PremiumTimelineAppBar({
    required this.isCalendarMode,
    required this.onViewModeChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 20,
        right: 20,
      ),
      child: PremiumGlassCard(
        padding: const EdgeInsets.all(20),
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
            // Title with geometric accent
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Timeline',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            PremiumIconButton(
              icon: isCalendarMode
                  ? Icons.view_list_rounded
                  : Icons.calendar_month_rounded,
              onPressed: onViewModeChanged,
              hasGlow: true,
            ),
            const SizedBox(width: 12),
            PremiumIconButton(
              icon: Icons.tune_rounded,
              onPressed: onFilterPressed,
            ),
          ],
        ),
      ),
    );
  }
}
