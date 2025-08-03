import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';
import 'stores/moment_store.dart';
import 'stores/auth_store.dart';
import 'stores/search_store.dart';
import 'stores/theme_store.dart';
import 'routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/capture/capture_screen.dart';
import 'consts/env_config.dart';
import 'utils/app_logger.dart';

/// Custom scroll behavior to unify iOS and Android scroll effects
class CustomScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use bouncing physics on all platforms to avoid Android over-stretch deformation
    return const BouncingScrollPhysics();
  }
}

class DiaryXApp extends StatelessWidget {
  const DiaryXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => MomentStore()),
        ChangeNotifierProvider(create: (_) => SearchStore()),
        ChangeNotifierProvider(create: (_) => ThemeStore()..initTheme()),
      ],
      child: Consumer2<AuthStore, ThemeStore>(
        builder: (context, authStore, themeStore, child) {
          return MaterialApp(
            title: EnvConfig.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeStore.themeMode,
            debugShowCheckedModeBanner: false,
            scrollBehavior:
                CustomScrollBehavior(), // Set global scroll behavior
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.home: (context) => const HomeScreen(),
            },
            onGenerateRoute: (settings) {
              // Handle custom routes with animations
              switch (settings.name) {
                case AppRoutes.capture:
                  return _createSlideRoute(
                    const CaptureScreen(),
                    settings,
                    slideDirection: SlideDirection.up,
                  );
                default:
                  AppLogger.navigation(
                    'Unknown route',
                    settings.name ?? 'null',
                    settings.arguments as Map<String, dynamic>?,
                  );
                  return null;
              }
            },
          );
        },
      ),
    );
  }

  /// Create a custom slide route with smooth animation
  static PageRoute<T> _createSlideRoute<T extends Object?>(
    Widget page,
    RouteSettings settings, {
    SlideDirection slideDirection = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, _) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define slide direction offsets
        Offset beginOffset;
        switch (slideDirection) {
          case SlideDirection.up:
            beginOffset = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            beginOffset = const Offset(0.0, -1.0);
            break;
          case SlideDirection.left:
            beginOffset = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.right:
            beginOffset = const Offset(1.0, 0.0);
            break;
        }

        // Create slide animation with smooth curves
        final slideAnimation =
            Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
            );

        // Create fade animation for smoother transition
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
        );

        // Create scale animation for premium feel
        final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          ),
        );
      },
    );
  }
}

/// Slide direction for page transitions
enum SlideDirection { up, down, left, right }
