import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Store for managing bottom navigation state
class NavigationStore extends ChangeNotifier {
  int _currentTabIndex = 0;

  /// Current selected tab index
  int get currentTabIndex => _currentTabIndex;

  /// Switch to a specific tab
  void switchToTab(int index) {
    if (index >= 0 && index <= 3 && index != _currentTabIndex) {
      AppLogger.info('Switching to tab index: $index');
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  /// Switch to Timeline tab (index 0)
  void switchToTimeline() => switchToTab(0);

  /// Switch to Insight tab (index 1)
  void switchToInsight() => switchToTab(1);

  /// Switch to Chat tab (index 2)
  void switchToChat() => switchToTab(2);

  /// Switch to Profile tab (index 3)
  void switchToProfile() => switchToTab(3);
}
