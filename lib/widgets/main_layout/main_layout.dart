import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../consts/env_config.dart';

/// Main layout with bottom navigation
class MainLayout extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<Widget> children;
  final List<BottomNavigationBarItem> items;

  const MainLayout({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.children,
    required this.items,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // No animation controllers needed - AnimatedSwitcher will handle it

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: EnvConfig.mediumAnimationDuration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        child: Container(
          key: ValueKey<int>(
            widget.currentIndex,
          ), // Important: key for AnimatedSwitcher
          child: widget.children[widget.currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.grey).withValues(
                alpha: 0.1,
              ),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            // AnimatedSwitcher will handle the animation automatically
            if (index != widget.currentIndex) {
              widget.onTabChanged(index);
            }
          },
          items: widget.items,
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          selectedItemColor: isDark
              ? AppColors.darkPrimary
              : AppColors.lightPrimary,
          unselectedItemColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
        ),
      ),
    );
  }
}

/// Bottom navigation items configuration
class BottomNavItems {
  static List<BottomNavigationBarItem> get items => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.timeline),
      activeIcon: Icon(Icons.timeline),
      label: 'Timeline',
      tooltip: 'View your diary moments',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.analytics_outlined),
      activeIcon: Icon(Icons.analytics),
      label: 'Report',
      tooltip: 'View analytics and insights',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline, size: 32),
      activeIcon: Icon(Icons.add_circle, size: 32),
      label: 'Capture',
      tooltip: 'Create new moment',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Search',
      tooltip: 'Search moments',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
      tooltip: 'Settings and profile',
    ),
  ];
}

/// Floating action button for capture
class CaptureFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const CaptureFloatingActionButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: isActive
          ? (isDark ? AppColors.darkAccent : AppColors.lightAccent)
          : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
      foregroundColor: Colors.white,
      elevation: 4,
      child: AnimatedSwitcher(
        duration: EnvConfig.shortAnimationDuration,
        child: Icon(
          isActive ? Icons.close : Icons.add,
          key: ValueKey(isActive),
          size: 28,
        ),
      ),
    );
  }
}

/// Custom tab indicator for special effects
class CustomTabIndicator extends StatelessWidget {
  final bool isActive;
  final Widget child;

  const CustomTabIndicator({
    super.key,
    required this.isActive,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: EnvConfig.shortAnimationDuration,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  .withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

/// Bottom sheet for quick actions
class QuickActionsBottomSheet extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsBottomSheet({super.key, required this.actions});

  static void show(BuildContext context, List<QuickAction> actions) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsBottomSheet(actions: actions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          ...actions.map(
            (action) => ListTile(
              leading: Icon(action.icon),
              title: Text(action.title),
              subtitle: action.subtitle != null ? Text(action.subtitle!) : null,
              onTap: () {
                Navigator.of(context).pop();
                action.onTap();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Quick action model
class QuickAction {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
