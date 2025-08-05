import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../app_button/app_button.dart';

/// Generic error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showRetry;

  const ErrorState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionText,
    this.onAction,
    this.showRetry = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (showRetry || onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText ?? 'Try Again',
                onPressed: onAction,
                type: AppButtonType.primary,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    (isDark
                            ? AppColors.darkSecondary
                            : AppColors.lightSecondary)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 48,
                color: isDark
                    ? AppColors.darkSecondary
                    : AppColors.lightSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: actionText ?? 'Get Started',
                onPressed: onAction,
                type: AppButtonType.primary,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network error state
class NetworkErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      actionText: 'Retry',
      onAction: onRetry,
    );
  }
}

/// No moments empty state
class NoMomentsState extends StatelessWidget {
  final VoidCallback? onCreateMoment;

  const NoMomentsState({super.key, this.onCreateMoment});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'No Moments Yet',
      message: 'Start your journaling journey by creating your first moment.',
      icon: Icons.edit_note,
      actionText: 'Create Moment',
      onAction: onCreateMoment,
    );
  }
}

/// No search results state
class NoSearchResultsState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const NoSearchResultsState({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'No Results Found',
      message:
          'No moments match "$searchQuery". Try different keywords or check your filters.',
      icon: Icons.search_off,
      actionText: 'Clear Search',
      onAction: onClearSearch,
    );
  }
}

/// AI processing error state
class AIProcessingErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const AIProcessingErrorState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: 'AI Processing Failed',
      message:
          'Unable to process your request with AI. You can still use the app normally.',
      icon: Icons.psychology_outlined,
      actionText: 'Retry',
      onAction: onRetry,
    );
  }
}

/// Permission denied state
class PermissionDeniedState extends StatelessWidget {
  final String permissionType;
  final VoidCallback? onRequestPermission;

  const PermissionDeniedState({
    super.key,
    required this.permissionType,
    this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: 'Permission Required',
      message: 'DiaryX needs $permissionType permission to function properly.',
      icon: Icons.lock_outline,
      actionText: 'Grant Permission',
      onAction: onRequestPermission,
    );
  }
}
