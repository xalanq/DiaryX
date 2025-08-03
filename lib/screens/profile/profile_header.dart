part of 'profile_screen.dart';

/// Premium welcome header with enhanced geometric design
class _PremiumWelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
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
        children: [
          // Compact geometric design
          ScaleInBounce(
            delay: const Duration(milliseconds: 200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background glow effect
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                // Main icon container with compact design
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                // Floating accent dots
                Positioned(
                  top: 8,
                  right: 12,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? AppColors.darkAccent
                                  : AppColors.lightAccent)
                              .withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? AppColors.darkSecondary
                                  : AppColors.lightSecondary)
                              .withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Compact title with version
          FadeInSlideUp(
            delay: const Duration(milliseconds: 400),
            child: Column(
              children: [
                Text(
                  'Welcome to DiaryX',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Compact subtitle
          FadeInSlideUp(
            delay: const Duration(milliseconds: 600),
            child: Text(
              'Your personal space for memories,\nthoughts, and AI-powered insights',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
