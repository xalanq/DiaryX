part of 'capture_screen.dart';

/// Balanced welcome header for capture screen
class _PremiumWelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeInSlideUp(
      delay: const Duration(milliseconds: 200),
      child: Column(
        children: [
          // Simple decorative element
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.getPrimaryGradient(isDark),
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Main title with enhanced styling
          Text(
            'What\'s on your mind?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtle subtitle
          Text(
            'Choose your capture method',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
