part of 'splash_screen.dart';

/// Premium authentication form
class _PremiumAuthForm extends StatelessWidget {
  final AuthStore authStore;
  final String password;
  final String? errorMessage;
  final bool isLoading;
  final int? storedPasswordLength;
  final Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;
  final bool isDark;

  const _PremiumAuthForm({
    required this.authStore,
    required this.password,
    this.errorMessage,
    required this.isLoading,
    this.storedPasswordLength,
    required this.onNumberPressed,
    required this.onDeletePressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumGlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Enter your password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Password dots with premium styling
          _PremiumPasswordDots(
            length: password.length,
            hasError: errorMessage != null,
            expectedLength: storedPasswordLength,
            isDark: isDark,
          ),

          // Error message with premium styling
          if (errorMessage != null) ...[
            const SizedBox(height: 24),
            FadeInSlideUp(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: isDark ? 0.2 : 0.1),
                      Colors.red.withValues(alpha: isDark ? 0.1 : 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Numeric keypad
          NumericKeypad(
            onNumberPressed: onNumberPressed,
            onDeletePressed: onDeletePressed,
            enabled: !isLoading,
          ),
        ],
      ),
    );
  }
}

/// Premium password dots display
class _PremiumPasswordDots extends StatelessWidget {
  final int length;
  final bool hasError;
  final int? expectedLength;
  final bool isDark;

  const _PremiumPasswordDots({
    required this.length,
    required this.hasError,
    this.expectedLength,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate the number of dots to display, keeping consistent with original component logic
    final displayLength =
        expectedLength ??
        (length == 0 ? 4 : (length < 4 ? 4 : (length > 6 ? 6 : length)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(displayLength, (index) {
        final isFilled = index < length;
        final isError = hasError;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isFilled
                ? (isError
                      ? LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.red.withValues(alpha: 0.7),
                          ],
                        )
                      : LinearGradient(
                          colors: AppColors.getPrimaryGradient(isDark),
                        ))
                : null,
            color: !isFilled
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1))
                : null,
            border: isDark
                ? Border.all(
                    color: isFilled
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color:
                          (isError
                                  ? Colors.red
                                  : (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary))
                              .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
