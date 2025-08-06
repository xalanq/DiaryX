import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../timeline/timeline_screen.dart';
import '../insight/insight_screen.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/main_layout/main_layout.dart';
import '../../stores/navigation_store.dart';
import '../../utils/app_logger.dart';

/// Home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;

  // Import the screen classes we created
  final List<Widget> _screens = const [
    TimelineScreen(),
    InsightScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationStore>(
      builder: (context, navigationStore, child) {
        return MainLayout(
          currentIndex: navigationStore.currentTabIndex,
          onTabChanged: (index) {
            final previousIndex = navigationStore.currentTabIndex;
            navigationStore.switchToTab(index);

            // More detailed logging for debugging navigation
            final tabNames = ['Timeline', 'Insight', 'Chat', 'Profile'];
            final previousTab = previousIndex < tabNames.length
                ? tabNames[previousIndex]
                : 'Unknown';
            final currentTab = index < tabNames.length
                ? tabNames[index]
                : 'Unknown';

            AppLogger.navigation(previousTab, currentTab, {
              'previousIndex': previousIndex,
              'currentIndex': index,
            });
          },
          items: BottomNavItems.items,
          children: _screens,
        );
      },
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
      label: 'Insight',
      tooltip: 'View insights and analytics',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.auto_awesome),
      activeIcon: Icon(Icons.auto_awesome),
      label: 'Chat',
      tooltip: 'AI conversations',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: 'Profile',
      tooltip: 'Profile and settings',
    ),
  ];
}
