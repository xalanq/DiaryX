import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiWrapper extends StatelessWidget {
  final Widget child;

  const SystemUiWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark
            ? const Color(0xFF0A0A0C)
            : Colors.white.withValues(alpha: 0.95),
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
