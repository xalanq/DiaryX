import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../stores/auth_store.dart';
import '../../routes.dart';
import '../../consts/env_config.dart';
import '../../utils/app_logger.dart';
import '../../widgets/glass_card/glass_card.dart';
import '../../widgets/app_button/app_button.dart';

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
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Transition animations
  late Animation<double> _logoMoveAnimation;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _authFadeAnimation;
  late Animation<double> _loadingFadeAnimation;

  // Auth form controllers
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  // State management
  SplashPhase _currentPhase = SplashPhase.loading;
  bool _isLoading = false;
  String? _errorMessage;

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _splashAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
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

    _logoMoveAnimation = Tween<double>(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _logoSizeAnimation = Tween<double>(begin: 1.0, end: 0.83).animate(
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
      // Add minimum splash duration for better UX
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check if widget is still mounted before proceeding
      if (!mounted) return;

      // Initialize authentication store
      final authStore = context.read<AuthStore>();
      await authStore.initialize();

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

    // Auto-focus password field after animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _passwordFocusNode.requestFocus();
      }
    });
  }

  void _transitionToComplete() {
    setState(() {
      _currentPhase = SplashPhase.complete;
    });

    // Navigate to home after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  Future<void> _handleAuthentication() async {
    final password = _passwordController.text.trim();

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
        await authStore.setupPassword(password);
        AppLogger.info('Password setup completed');
      } else {
        // Authentication
        final success = await authStore.authenticate(password);
        if (!success) {
          _showError('Incorrect password');
          return;
        }
        AppLogger.info('Authentication successful');
      }

      // Navigate to home screen
      _transitionToComplete();
    } catch (e) {
      AppLogger.error('Authentication failed', e);
      _showError('Authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
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
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _splashAnimationController.dispose();
    _transitionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authStore = context.watch<AuthStore>();

    // Colors that adapt to theme
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
        animation: Listenable.merge([
          _splashAnimationController,
          _transitionAnimationController,
        ]),
        builder: (context, child) {
          // Animated logo size - starts at 120, ends at ~100
          final logoSize = 120.0 * _logoSizeAnimation.value;
          final iconSize = logoSize * 0.533; // Keep proportional
          final logoRadius = logoSize * 0.2; // Keep proportional

          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Animated logo section that moves and scales
                        Transform.translate(
                          offset: Offset(0, _logoMoveAnimation.value),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // App Icon with continuous animation
                                  Center(
                                    child: Container(
                                      width: logoSize,
                                      height: logoSize,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          logoRadius,
                                        ),
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
                                                ? Colors.black.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : theme.colorScheme.primary
                                                      .withValues(alpha: 0.2),
                                            blurRadius: isDarkMode ? 10 : 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.book_outlined,
                                        size: iconSize,
                                        color: iconColor,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: _currentPhase == SplashPhase.auth
                                        ? 20
                                        : 32,
                                  ),

                                  // App Name with size animation
                                  Text(
                                    EnvConfig.appName,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontSize:
                                              _currentPhase == SplashPhase.auth
                                              ? 32
                                              : 36,
                                          fontWeight: FontWeight.bold,
                                          color: titleColor,
                                          letterSpacing: -0.5,
                                        ),
                                  ),

                                  SizedBox(
                                    height: _currentPhase == SplashPhase.auth
                                        ? 6
                                        : 12,
                                  ),

                                  // Conditional content based on phase
                                  if (_currentPhase == SplashPhase.loading)
                                    Text(
                                      'Your private diary companion',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontSize: 18,
                                            color: taglineColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    )
                                  else
                                    Text(
                                      authStore.isPasswordSetup
                                          ? 'Welcome back!'
                                          : 'Set up your password',
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(color: taglineColor),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Loading indicator (fades out during transition)
                        if (_currentPhase == SplashPhase.loading)
                          FadeTransition(
                            opacity: _loadingFadeAnimation,
                            child: Column(
                              children: [
                                const SizedBox(height: 64),
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      loadingColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Auth form (fades in during transition)
                        if (_currentPhase == SplashPhase.auth)
                          FadeTransition(
                            opacity: _authFadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 24),

                                GlassCard(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        authStore.isPasswordSetup
                                            ? 'Enter your password'
                                            : 'Create a 4-6 digit password',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),

                                      // Password input
                                      ValueListenableBuilder(
                                        valueListenable: _passwordController,
                                        builder: (context, value, child) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                                if (value.text.length >= 4 &&
                                                    value.text.length <= 6 &&
                                                    !_isLoading) {
                                                  _handleAuthentication();
                                                }
                                              });

                                          return TextFormField(
                                            controller: _passwordController,
                                            focusNode: _passwordFocusNode,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                6,
                                              ),
                                            ],
                                            obscureText: true,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                  letterSpacing:
                                                      value.text.isEmpty
                                                      ? 2
                                                      : 8,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              hintText: value.text.isEmpty
                                                  ? '● ● ● ●'
                                                  : null,
                                              hintStyle: theme
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant
                                                        .withValues(alpha: 0.4),
                                                    letterSpacing: 8,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: theme
                                                  .colorScheme
                                                  .surfaceContainerHighest
                                                  .withValues(alpha: 0.5),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 16,
                                                  ),
                                            ),
                                            onFieldSubmitted: (_) =>
                                                _handleAuthentication(),
                                          );
                                        },
                                      ),

                                      // Error message
                                      if (_errorMessage != null) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme
                                                .colorScheme
                                                .errorContainer,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                size: 16,
                                                color: theme
                                                    .colorScheme
                                                    .onErrorContainer,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _errorMessage!,
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .onErrorContainer,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],

                                      const SizedBox(height: 24),

                                      // Submit button
                                      AppButton(
                                        text: authStore.isPasswordSetup
                                            ? 'Enter'
                                            : 'Set Password',
                                        onPressed: _isLoading
                                            ? null
                                            : _handleAuthentication,
                                        isLoading: _isLoading,
                                        size: AppButtonSize.full,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Helper text
                                Text(
                                  authStore.isPasswordSetup
                                      ? 'Enter your 4-6 digit password to continue'
                                      : 'Choose a secure 4-6 digit password for your diary',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
