import 'package:diaryx/widgets/annotated_region/system_ui_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../stores/auth_store.dart';
import '../../routes.dart';
import '../../consts/env_config.dart';
import '../../utils/app_logger.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/numeric_keypad/numeric_keypad.dart';
import '../../themes/app_colors.dart';

part 'splash_animations.dart';
part 'splash_auth.dart';

/// Phases of the splash screen
enum SplashPhase {
  loading, // Initial loading with spinner
  auth, // Show authentication form
  complete, // Ready to navigate to home
}

/// Splash screen for application initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _splashAnimationController;
  late AnimationController _transitionAnimationController;

  // Splash animations
  late Animation<double> _scaleAnimation;

  // Transition animations
  late Animation<double> _logoMoveAnimation;
  late Animation<double> _authFadeAnimation;
  late Animation<double> _loadingFadeAnimation;

  // Password state
  String _password = '';

  // State management
  SplashPhase _currentPhase = SplashPhase.loading;
  bool _isLoading = false;
  String? _errorMessage;
  int? _storedPasswordLength;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Splash animation controller
    _splashAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _splashAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Transition animation controller
    _transitionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoMoveAnimation = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _loadingFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _authFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _splashAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    AppLogger.info('Initializing application');

    // Use post frame callback to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize authentication store
      final authStore = context.read<AuthStore>();
      await Future.wait([
        authStore.initialize(),
        Future.delayed(const Duration(milliseconds: 2000)),
      ]);

      // Get stored password length for auto-authentication logic
      if (authStore.isPasswordSetup) {
        _storedPasswordLength = await authStore.getStoredPasswordLength();
      }

      // Determine next phase
      if (!mounted) return;

      if (authStore.isPasswordSetup && authStore.isAuthenticated) {
        // User is already authenticated, go to home
        _transitionToComplete();
      } else {
        // Need authentication, show auth form
        _transitionToAuth();
      }
    });
  }

  void _transitionToAuth() {
    setState(() {
      _currentPhase = SplashPhase.auth;
    });
    _transitionAnimationController.forward();
  }

  void _transitionToComplete() {
    // Navigate to capture immediately when authentication is complete
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.capture,
        arguments: {'isFromSplash': true},
      );
    }
  }

  Future<void> _handleAuthentication() async {
    final password = _password.trim();

    // Basic validation
    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }

    if (password.length < 4 || password.length > 6) {
      _showError('Password must be 4-6 digits');
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(password)) {
      _showError('Password must contain only numbers');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authStore = context.read<AuthStore>();

      if (!authStore.isPasswordSetup) {
        // First time setup
        final setupSuccess = await authStore.setupPassword(password);
        if (!setupSuccess) {
          await Future.delayed(Duration(milliseconds: 1000));
          // Use the specific error message from AuthStore, fallback to generic message
          _showError(authStore.error ?? 'Failed to setup password');
          return;
        }
        AppLogger.info('Password setup completed');
      } else {
        // Authentication
        final success = await authStore.authenticate(password);
        if (!success) {
          await Future.delayed(Duration(milliseconds: 1000));
          // Use the specific error message from AuthStore, fallback to generic message
          _showError(authStore.error ?? 'Incorrect password');
          return;
        }
        AppLogger.info('Authentication successful');
      }

      // Navigate to home screen
      _transitionToComplete();
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 1000));
      AppLogger.error('Authentication failed', e);
      // Use the specific error message from AuthStore, fallback to generic message
      _showError('Authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onNumberPressed(String number) {
    if (_password.length < 6 && !_isLoading) {
      setState(() {
        _password += number;
        _errorMessage = null; // Clear any error when typing
      });

      final authStore = context.read<AuthStore>();

      // Auto-authenticate when reaching the exact stored password length
      // For first-time setup, allow 4-6 digits before auto-authentication
      if (!_isLoading) {
        if (authStore.isPasswordSetup) {
          // For existing users, only auto-authenticate when length matches stored password
          if (_storedPasswordLength != null &&
              _password.length == _storedPasswordLength) {
            _handleAuthentication();
          }
        } else {
          // For first-time setup, auto-authenticate when reaching 4-6 digits
          if (_password.length >= 4) {
            _handleAuthentication();
          }
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_password.isNotEmpty && !_isLoading) {
      setState(() {
        _password = _password.substring(0, _password.length - 1);
        _errorMessage = null; // Clear any error when deleting
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _password = ''; // Clear password on error
    });

    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Clear error after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _splashAnimationController.dispose();
    _transitionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authStore = context.watch<AuthStore>();

    return SystemUiWrapper(
      child: Scaffold(
        extendBody: true,
        body: PremiumScreenBackground(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _splashAnimationController,
              _transitionAnimationController,
            ]),
            builder: (context, child) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Premium animated logo section
                        Transform.translate(
                          offset: Offset(0, _logoMoveAnimation.value),
                          child: FadeInSlideUp(
                            delay: Duration.zero,
                            child: ScaleInBounce(
                              delay: const Duration(milliseconds: 200),
                              child: Column(
                                children: [
                                  // Premium app icon with glow effect
                                  _PremiumAppIcon(
                                    size: _currentPhase == SplashPhase.auth
                                        ? 100.0
                                        : 120.0,
                                    isDark: isDark,
                                    animation: _scaleAnimation,
                                  ),

                                  SizedBox(
                                    height: _currentPhase == SplashPhase.auth
                                        ? 24
                                        : 32,
                                  ),

                                  // App name with premium styling
                                  Text(
                                    EnvConfig.appName,
                                    style: theme.textTheme.headlineLarge?.copyWith(
                                      fontSize:
                                          _currentPhase == SplashPhase.auth
                                          ? 32
                                          : 40,
                                      fontWeight: FontWeight.w800,
                                      foreground: Paint()
                                        ..shader =
                                            LinearGradient(
                                              colors:
                                                  AppColors.getPrimaryGradient(
                                                    isDark,
                                                  ),
                                            ).createShader(
                                              const Rect.fromLTWH(
                                                0,
                                                0,
                                                200,
                                                50,
                                              ),
                                            ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: _currentPhase == SplashPhase.auth
                                        ? 12
                                        : 16,
                                  ),

                                  // Tagline with fade animation
                                  Text(
                                    _currentPhase == SplashPhase.loading
                                        ? 'Your private diary companion'
                                        : (authStore.isPasswordSetup
                                              ? 'Welcome back!'
                                              : 'Set up your password'),
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize:
                                          _currentPhase == SplashPhase.loading
                                          ? 18
                                          : 16,
                                      color: theme.textTheme.bodyLarge?.color
                                          ?.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Loading state with premium animation
                        if (_currentPhase == SplashPhase.loading)
                          FadeTransition(
                            opacity: _loadingFadeAnimation,
                            child: Column(
                              children: [
                                const SizedBox(height: 64),
                                _PremiumLoadingIndicator(isDark: isDark),
                              ],
                            ),
                          ),

                        // Premium auth form
                        if (_currentPhase == SplashPhase.auth)
                          FadeTransition(
                            opacity: _authFadeAnimation,
                            child: RevealAnimation(
                              delay: Duration(milliseconds: 100),
                              duration: PremiumAnimations.normal,
                              curve: PremiumAnimations.easeOut,
                              child: _PremiumAuthForm(
                                authStore: authStore,
                                password: _password,
                                errorMessage: _errorMessage,
                                isLoading: _isLoading,
                                storedPasswordLength: _storedPasswordLength,
                                onNumberPressed: _onNumberPressed,
                                onDeletePressed: _onDeletePressed,
                                isDark: isDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
