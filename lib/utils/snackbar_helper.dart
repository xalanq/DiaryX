import 'package:flutter/material.dart';

/// Global SnackBar helper with consistent positioning above bottom navigation
class SnackBarHelper {
  /// Private constructor to prevent instantiation
  SnackBarHelper._();

  /// Show success SnackBar with consistent positioning
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    IconData icon = Icons.check_circle_rounded,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: icon,
      duration: duration,
    );
  }

  /// Show error SnackBar with consistent positioning
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    IconData icon = Icons.error_rounded,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: icon,
      duration: duration,
    );
  }

  /// Show info SnackBar with consistent positioning
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    IconData icon = Icons.info_rounded,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: icon,
      duration: duration,
    );
  }

  /// Show warning SnackBar with consistent positioning
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    IconData icon = Icons.warning_rounded,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.orange.shade600,
      icon: icon,
      duration: duration,
    );
  }

  /// Internal method to show SnackBar with consistent positioning
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    // Clear any existing SnackBar first
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom:
              MediaQuery.of(context).viewPadding.bottom +
              32, // Above bottom navigation
        ),
        duration: duration,
        elevation: 6,
      ),
    );
  }
}
