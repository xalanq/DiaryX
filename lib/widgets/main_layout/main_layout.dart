import 'dart:ui';
import 'package:diaryx/widgets/annotated_region/system_ui_wrapper.dart';
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
    return SystemUiWrapper(
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // Main content - fills entire screen
            AnimatedSwitcher(
              duration: EnvConfig.mediumAnimationDuration,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
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
            // Bottom navigation bar overlaid on content
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _PremiumBottomNavBar(
                currentIndex: widget.currentIndex,
                onTap: (index) {
                  if (index != widget.currentIndex) {
                    widget.onTabChanged(index);
                  }
                },
                items: widget.items,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom navigation items configuration with premium icons
class BottomNavItems {
  static List<BottomNavigationBarItem> get items => [
    const BottomNavigationBarItem(
      icon: Icon(Icons.access_time_outlined),
      activeIcon: Icon(Icons.access_time),
      label: 'Timeline',
      tooltip: 'View your journal entries',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.insights_outlined),
      activeIcon: Icon(Icons.insights),
      label: 'Report',
      tooltip: 'View insights and analytics',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.add_rounded, size: 24),
      activeIcon: Icon(Icons.add_rounded, size: 24),
      label: 'Capture',
      tooltip: 'Write new moment',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Search',
      tooltip: 'Discover moments',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: 'Profile',
      tooltip: 'Profile and settings',
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

/// Premium glass morphism bottom navigation bar
class _PremiumBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const _PremiumBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<_PremiumBottomNavBar> createState() => _PremiumBottomNavBarState();
}

class _PremiumBottomNavBarState extends State<_PremiumBottomNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    _animations = _controllers
        .map(
          (controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
          ),
        )
        .toList();

    // Start animation for current index
    _controllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(_PremiumBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return SizedBox(
      height: 90 + mediaQuery.viewPadding.bottom,
      child: Stack(
        children: [
          // Background glass effect
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 70 + mediaQuery.viewPadding.bottom,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                AppColors.darkSurface.withValues(alpha: 0.1),
                                AppColors.darkSurface.withValues(alpha: 0.4),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.95),
                                Colors.white.withValues(alpha: 1),
                              ],
                      ),
                      border: Border(
                        top: BorderSide(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.05),
                          width: 0.5,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.4 : 0.08,
                          ),
                          blurRadius: 30,
                          offset: const Offset(0, -10),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.2 : 0.03,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: mediaQuery.viewPadding.bottom,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: widget.items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final isSelected = index == widget.currentIndex;

                          // Skip the center item (index 2) - it will be rendered separately
                          if (index == 2) {
                            return const SizedBox(
                              width: 60,
                            ); // Space for floating button
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => widget.onTap(index),
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedBuilder(
                                animation: _animations[index],
                                builder: (context, child) {
                                  return SizedBox(
                                    height: 70,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Icon with animated container
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? LinearGradient(
                                                    colors:
                                                        AppColors.getPrimaryGradient(
                                                          isDark,
                                                        ),
                                                  )
                                                : null,
                                            shape: BoxShape.circle,
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color:
                                                          AppColors.getPrimaryGradient(
                                                            isDark,
                                                          )[0].withValues(
                                                            alpha: 0.3,
                                                          ),
                                                      blurRadius: 8,
                                                      spreadRadius: 1,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            child: Icon(
                                              isSelected
                                                  ? (item.activeIcon as Icon)
                                                        .icon
                                                  : (item.icon as Icon).icon,
                                              key: ValueKey(
                                                '$index-$isSelected',
                                              ),
                                              size: 24,
                                              color: isSelected
                                                  ? Colors.white
                                                  : (isDark
                                                        ? AppColors
                                                              .darkTextSecondary
                                                        : AppColors
                                                              .lightTextSecondary),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        // Label with animation
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? (isDark
                                                      ? AppColors
                                                            .darkTextPrimary
                                                      : AppColors
                                                            .lightTextPrimary)
                                                : (isDark
                                                      ? AppColors
                                                            .darkTextSecondary
                                                      : AppColors
                                                            .lightTextSecondary),
                                          ),
                                          child: Text(
                                            item.label ?? '',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Floating center button - protruding above nav bar
          Positioned(
            bottom: 20 + mediaQuery.viewPadding.bottom,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: GestureDetector(
              onTap: () => widget.onTap(2),
              child: AnimatedBuilder(
                animation: _animations[2],
                builder: (context, child) {
                  final isSelected = widget.currentIndex == 2;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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
                          color: AppColors.getPrimaryGradient(
                            isDark,
                          )[0].withValues(alpha: 0.4),
                          blurRadius: isSelected ? 20 : 15,
                          spreadRadius: isSelected ? 3 : 1,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.3 : 0.1,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.onTap(2),
                        customBorder: const CircleBorder(),
                        splashColor: Colors.white.withValues(alpha: 0.2),
                        highlightColor: Colors.white.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
