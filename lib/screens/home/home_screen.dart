import 'package:flutter/material.dart';

import '../timeline/timeline_screen.dart';
import '../report/report_screen.dart';
import '../capture/capture_screen.dart';
import '../search/search_screen.dart';
import '../profile/profile_screen.dart';
import '../../widgets/main_layout/main_layout.dart';
import '../../utils/app_logger.dart';

/// Home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  // Import the screen classes we created
  final List<Widget> _screens = const [
    TimelineScreen(),
    ReportScreen(),
    CaptureScreen(),
    SearchScreen(),
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
    return MainLayout(
      currentIndex: _currentIndex,
      onTabChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
        AppLogger.navigation('Tab changed', 'Tab $index', {'tabIndex': index});
      },
      items: BottomNavItems.items,
      children: _screens,
    );
  }
}
