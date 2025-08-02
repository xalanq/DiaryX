import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

/// Custom button widget following the app's design system
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: size == AppButtonSize.full ? double.infinity : null,
        height: _getHeight(),
        child: ElevatedButton(
          onPressed: (isEnabled && !isLoading) ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getBackgroundColor(isDark),
            foregroundColor: _getForegroundColor(isDark),
            elevation: type == AppButtonType.ghost ? 0 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: type == AppButtonType.ghost
                  ? BorderSide(color: _getBorderColor(isDark))
                  : BorderSide.none,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(),
              vertical: _getVerticalPadding(),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getForegroundColor(isDark),
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: _getIconSize()),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      text,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: _getFontSize(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (customColor != null) return customColor!;

    switch (type) {
      case AppButtonType.primary:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case AppButtonType.secondary:
        return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
      case AppButtonType.ghost:
        return Colors.transparent;
      case AppButtonType.destructive:
        return AppColors.error;
    }
  }

  Color _getForegroundColor(bool isDark) {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.destructive:
        return Colors.white;
      case AppButtonType.ghost:
        return isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    }
  }

  Color _getBorderColor(bool isDark) {
    return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
      case AppButtonSize.full:
        return 44;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
      case AppButtonSize.full:
        return 20;
    }
  }

  double _getVerticalPadding() {
    switch (size) {
      case AppButtonSize.small:
        return 8;
      case AppButtonSize.medium:
        return 10;
      case AppButtonSize.large:
        return 12;
      case AppButtonSize.full:
        return 10;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
      case AppButtonSize.full:
        return 18;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
      case AppButtonSize.full:
        return 14;
    }
  }
}

enum AppButtonType { primary, secondary, ghost, destructive }

enum AppButtonSize { small, medium, large, full }
