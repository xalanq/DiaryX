import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'stores/entry_store.dart';
import 'stores/auth_store.dart';
import 'stores/search_store.dart';
import 'routes.dart';
import 'screens/timeline/timeline_screen.dart';
import 'screens/report/report_screen.dart';
import 'screens/capture/capture_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'widgets/main_layout/main_layout.dart';
import 'consts/env_config.dart';
import 'utils/app_logger.dart';

class DiaryXApp extends StatelessWidget {
  const DiaryXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => EntryStore()),
        ChangeNotifierProvider(create: (_) => SearchStore()),
      ],
      child: Consumer<AuthStore>(
        builder: (context, authStore, child) {
          return MaterialApp(
            title: EnvConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.auth: (context) => const AuthScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
            },
            onGenerateRoute: (settings) {
              AppLogger.navigation(
                'Unknown route',
                settings.name ?? 'null',
                settings.arguments as Map<String, dynamic>?,
              );
              return null;
            },
          );
        },
      ),
    );
  }
}

/// Temporary splash screen for Phase 1
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    AppLogger.info('Initializing application');

    // Use post frame callback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize authentication store
      final authStore = context.read<AuthStore>();
      await authStore.initialize();

      // Navigate to appropriate screen
      if (!mounted) return;

      if (authStore.isPasswordSetup) {
        if (authStore.isAuthenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book, size: 80, color: Colors.white),
            SizedBox(height: 24),
            Text(
              EnvConfig.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your private diary companion',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Temporary authentication screen for Phase 1
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64, color: Colors.grey),
            SizedBox(height: 24),
            Text(
              'Authentication Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This will be implemented in Phase 3',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

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
