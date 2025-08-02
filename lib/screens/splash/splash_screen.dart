import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../stores/auth_store.dart';
import '../../routes.dart';
import '../../consts/env_config.dart';
import '../../utils/app_logger.dart';

/// Splash screen for application initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    AppLogger.info('Initializing application');

    // Use post frame callback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Add minimum splash duration for better UX
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Colors that adapt to theme - similar to auth page
    final containerGradientStart = theme.colorScheme.primary;
    final containerGradientEnd = theme.colorScheme.primary.withValues(
      alpha: 0.8,
    );
    final iconColor = theme.colorScheme.onPrimary;
    final titleColor = theme.colorScheme.onSurface;
    final taglineColor = theme.colorScheme.onSurfaceVariant;
    final loadingColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon with modern gradient effect
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            containerGradientStart,
                            containerGradientEnd,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withValues(alpha: 0.3)
                                : theme.colorScheme.primary.withValues(
                                    alpha: 0.2,
                                  ),
                            blurRadius: isDarkMode ? 10 : 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.book_outlined,
                        size: 64,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      EnvConfig.appName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // App Tagline
                    Text(
                      'Your private diary companion',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: taglineColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 64),

                    // Loading Indicator
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
