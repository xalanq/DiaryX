part of 'search_screen.dart';

/// Premium chat interface
class _PremiumChatInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return StaggeredAnimationContainer(
      staggerDelay: const Duration(milliseconds: 150),
      children: [
        const SizedBox(height: 16),
        // Chat welcome
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PremiumGlassCard(
            hasGradient: true,
            gradientColors: isDark
                ? [
                    AppColors.darkPrimary.withValues(alpha: 0.3),
                    AppColors.darkAccent.withValues(alpha: 0.1),
                  ]
                : [
                    AppColors.lightPrimary.withValues(alpha: 0.2),
                    AppColors.lightAccent.withValues(alpha: 0.1),
                  ],
            child: Column(
              children: [
                ScaleInBounce(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'AI Assistant',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ask me anything about your diary moments.\nI can help you find patterns and insights.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Phase 7',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Coming soon placeholder
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PremiumGlassCard(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 48,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Coming Soon',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.titleLarge?.color?.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Advanced AI chat features will be available in Phase 7',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.6,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
