part of 'search_screen.dart';

/// Premium filters panel
class _PremiumFiltersPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                size: 20,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
              const SizedBox(width: 12),
              Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  AppLogger.userAction('Clear all filters');
                },
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkAccent
                        : AppColors.lightAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PremiumFilterChip(label: 'Text', isSelected: false),
              _PremiumFilterChip(label: 'Voice', isSelected: false),
              _PremiumFilterChip(label: 'Images', isSelected: false),
              _PremiumFilterChip(label: 'Videos', isSelected: false),
              _PremiumFilterChip(label: 'This Week', isSelected: false),
              _PremiumFilterChip(label: 'This Month', isSelected: false),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Premium filter chip
class _PremiumFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _PremiumFilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppLogger.userAction('Filter selected', {'filter': label});
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: AppColors.getPrimaryGradient(isDark))
                : null,
            color: isSelected
                ? null
                : (isDark
                      ? AppColors.darkSurface.withValues(alpha: 0.6)
                      : AppColors.lightSurface.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1)),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
