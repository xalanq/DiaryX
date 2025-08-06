import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/numeric_keypad/numeric_keypad.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../stores/auth_store.dart';
import '../../themes/app_colors.dart';
import '../../utils/app_logger.dart';
import '../../routes.dart';

/// Password change phases
enum PasswordChangePhase {
  currentPassword, // Enter current password
  newPassword, // Enter new password
  confirmPassword, // Confirm new password
  success, // Success state
}

/// Change Password screen with splash-inspired design
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _primaryAnimationController;
  late AnimationController _transitionAnimationController;
  late AnimationController _successAnimationController;

  // Animations
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _successScaleAnimation;

  // Password state
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  // State management
  PasswordChangePhase _currentPhase = PasswordChangePhase.currentPassword;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Change password screen opened');
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Primary animation controller for main content
    _primaryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Transition animation for phase changes
    _transitionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Success animation controller
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation for main content
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _primaryAnimationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Fade animation for transitions
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Slide animation for content changes
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _transitionAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Success scale animation
    _successScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start main animation
    _primaryAnimationController.forward();
    _transitionAnimationController.forward();
  }

  @override
  void dispose() {
    _primaryAnimationController.dispose();
    _transitionAnimationController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  String get _currentPasswordForPhase {
    switch (_currentPhase) {
      case PasswordChangePhase.currentPassword:
        return _currentPassword;
      case PasswordChangePhase.newPassword:
        return _newPassword;
      case PasswordChangePhase.confirmPassword:
        return _confirmPassword;
      default:
        return '';
    }
  }

  String get _phaseTitle {
    switch (_currentPhase) {
      case PasswordChangePhase.currentPassword:
        return 'Enter Current Password';
      case PasswordChangePhase.newPassword:
        return 'Choose New Password';
      case PasswordChangePhase.confirmPassword:
        return 'Confirm Password';
      case PasswordChangePhase.success:
        return 'Password Changed!';
    }
  }

  String get _phaseSubtitle {
    switch (_currentPhase) {
      case PasswordChangePhase.currentPassword:
        return 'Please verify your current password to continue';
      case PasswordChangePhase.newPassword:
        return 'Create a new 4-6 digit numeric password';
      case PasswordChangePhase.confirmPassword:
        return 'Re-enter your new password to confirm';
      case PasswordChangePhase.success:
        return 'Your password has been updated successfully';
    }
  }

  void _onNumberPressed(String number) {
    if (_isLoading || _currentPhase == PasswordChangePhase.success) return;

    final currentPassword = _currentPasswordForPhase;
    if (currentPassword.length >= 6) return;

    HapticFeedback.lightImpact();

    setState(() {
      _errorMessage = null;
      switch (_currentPhase) {
        case PasswordChangePhase.currentPassword:
          _currentPassword += number;
          break;
        case PasswordChangePhase.newPassword:
          _newPassword += number;
          break;
        case PasswordChangePhase.confirmPassword:
          _confirmPassword += number;
          break;
        case PasswordChangePhase.success:
          break;
      }
    });

    // Auto-advance based on password length
    final updatedPassword = _currentPasswordForPhase;
    if (updatedPassword.length >= 4 && !_isLoading) {
      if (mounted) {
        _handlePhaseCompletion();
      }
    }
  }

  void _onDeletePressed() {
    if (_isLoading || _currentPhase == PasswordChangePhase.success) return;

    HapticFeedback.lightImpact();

    setState(() {
      _errorMessage = null;
      switch (_currentPhase) {
        case PasswordChangePhase.currentPassword:
          if (_currentPassword.isNotEmpty) {
            _currentPassword = _currentPassword.substring(
              0,
              _currentPassword.length - 1,
            );
          }
          break;
        case PasswordChangePhase.newPassword:
          if (_newPassword.isNotEmpty) {
            _newPassword = _newPassword.substring(0, _newPassword.length - 1);
          }
          break;
        case PasswordChangePhase.confirmPassword:
          if (_confirmPassword.isNotEmpty) {
            _confirmPassword = _confirmPassword.substring(
              0,
              _confirmPassword.length - 1,
            );
          }
          break;
        case PasswordChangePhase.success:
          break;
      }
    });
  }

  void _handlePhaseCompletion() {
    switch (_currentPhase) {
      case PasswordChangePhase.currentPassword:
        _validateCurrentPassword();
        break;
      case PasswordChangePhase.newPassword:
        _transitionToNextPhase(PasswordChangePhase.confirmPassword);
        break;
      case PasswordChangePhase.confirmPassword:
        _submitPasswordChange();
        break;
      case PasswordChangePhase.success:
        break;
    }
  }

  void _transitionToNextPhase(PasswordChangePhase nextPhase) {
    _transitionAnimationController.reset();
    setState(() {
      _currentPhase = nextPhase;
    });
    _transitionAnimationController.forward();
  }

  void _goBackToPreviousPhase() {
    PasswordChangePhase previousPhase;
    switch (_currentPhase) {
      case PasswordChangePhase.newPassword:
        previousPhase = PasswordChangePhase.currentPassword;
        setState(() {
          _currentPassword = '';
        });
        break;
      case PasswordChangePhase.confirmPassword:
        previousPhase = PasswordChangePhase.newPassword;
        setState(() {
          _newPassword = '';
        });
        break;
      default:
        return;
    }

    _transitionAnimationController.reset();
    setState(() {
      _currentPhase = previousPhase;
      _errorMessage = null;
    });
    _transitionAnimationController.forward();
  }

  Future<void> _submitPasswordChange() async {
    // Validation - only need to check new password format and matching
    if (_newPassword.isEmpty || _newPassword.length < 4) {
      _showError('New password must be at least 4 digits');
      return;
    }

    if (_newPassword != _confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authStore = Provider.of<AuthStore>(context, listen: false);
      // Current password has already been validated, so this should succeed
      final success = await authStore.changePassword(
        _currentPassword,
        _newPassword,
      );

      if (success) {
        // Success state
        setState(() {
          _currentPhase = PasswordChangePhase.success;
        });

        _successAnimationController.forward();
        HapticFeedback.heavyImpact();

        AppLogger.userAction('Password changed successfully');

        // Auto-navigate back after success
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            AppRoutes.pop(context);
          }
        });
      } else {
        // This should rarely happen since we validated the current password
        _showError(authStore.error ?? 'Failed to change password');
        _resetToFirstPhase();
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
      AppLogger.error('Password change error', e);
      _resetToFirstPhase();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });

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

  void _resetToFirstPhase() {
    _transitionAnimationController.reset();
    setState(() {
      _currentPhase = PasswordChangePhase.currentPassword;
      _currentPassword = '';
      _newPassword = '';
      _confirmPassword = '';
    });
    _transitionAnimationController.forward();
  }

  Future<void> _validateCurrentPassword() async {
    if (_currentPassword.isEmpty || _currentPassword.length < 4) {
      _showError('Current password must be at least 4 digits');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authStore = Provider.of<AuthStore>(context, listen: false);

      // Create a temporary authentication attempt to validate current password
      // We'll temporarily store the current auth state
      final wasAuthenticated = authStore.isAuthenticated;

      // Try to authenticate with the current password
      final isValid = await authStore.authenticate(_currentPassword);

      if (isValid) {
        // Password is correct, restore auth state and proceed to next phase
        if (!wasAuthenticated) {
          // If user wasn't authenticated before, restore that state
          authStore.logout();
        }
        _transitionToNextPhase(PasswordChangePhase.newPassword);
      } else {
        // Password is incorrect
        _showError(authStore.error ?? 'Current password is incorrect');
        setState(() {
          _currentPassword = '';
        });
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
      AppLogger.error('Current password validation error', e);
      setState(() {
        _currentPassword = '';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: Scaffold(
        extendBody: true,
        body: PremiumScreenBackground(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _primaryAnimationController,
              _transitionAnimationController,
              _successAnimationController,
            ]),
            builder: (context, child) {
              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Back button (styled like splash page)
                        if (_currentPhase != PasswordChangePhase.success)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FadeInSlideUp(
                              delay: Duration.zero,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: theme.textTheme.bodyLarge?.color
                                      ?.withValues(alpha: 0.7),
                                  size: 24,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : (_currentPhase ==
                                              PasswordChangePhase
                                                  .currentPassword
                                          ? () => AppRoutes.pop(context)
                                          : _goBackToPreviousPhase),
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        // Premium lock icon with glow effect (like splash logo)
                        Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeInSlideUp(
                            delay: const Duration(milliseconds: 100),
                            child: ScaleInBounce(
                              delay: const Duration(milliseconds: 200),
                              child: _buildSecurityIcon(isDark),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Phase title and subtitle (like splash design)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Column(
                              children: [
                                // Phase title with gradient text
                                Text(
                                  _phaseTitle,
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    foreground: Paint()
                                      ..shader =
                                          LinearGradient(
                                            colors:
                                                _currentPhase ==
                                                    PasswordChangePhase.success
                                                ? [
                                                    Colors.green,
                                                    Colors.green.withValues(
                                                      alpha: 0.7,
                                                    ),
                                                  ]
                                                : AppColors.getPrimaryGradient(
                                                    isDark,
                                                  ),
                                          ).createShader(
                                            const Rect.fromLTWH(0, 0, 200, 50),
                                          ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 16),

                                // Phase subtitle
                                Text(
                                  _phaseSubtitle,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
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

                        const SizedBox(height: 48),

                        // Password dots or loading indicator
                        if (_currentPhase != PasswordChangePhase.success)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _isLoading
                                  ? _buildLoadingIndicator(theme, isDark)
                                  : _buildPasswordDots(theme, isDark),
                            ),
                          ),

                        // Success icon for success phase
                        if (_currentPhase == PasswordChangePhase.success)
                          ScaleTransition(
                            scale: _successScaleAnimation,
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 80,
                              color: Colors.green,
                            ),
                          ),

                        // Error message
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 24),
                          FadeInSlideUp(
                            child: Text(
                              _errorMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],

                        const SizedBox(height: 64),

                        // Numeric keypad (only show for input phases)
                        if (_currentPhase != PasswordChangePhase.success)
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: _buildNumericKeypad(),
                            ),
                          ),

                        const SizedBox(height: 32),
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

  // Build security icon with glow effect (inspired by splash logo)
  Widget _buildSecurityIcon(bool isDark) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: RadialGradient(
          colors: _currentPhase == PasswordChangePhase.success
              ? [
                  Colors.green.withValues(alpha: 0.2),
                  Colors.green.withValues(alpha: 0.05),
                  Colors.transparent,
                ]
              : [
                  (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      .withValues(alpha: 0.2),
                  (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      .withValues(alpha: 0.05),
                  Colors.transparent,
                ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _currentPhase == PasswordChangePhase.success
                ? Colors.green.withValues(alpha: 0.3)
                : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                      .withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        _currentPhase == PasswordChangePhase.success
            ? Icons.check_circle_rounded
            : Icons.lock_rounded,
        size: 48,
        color: _currentPhase == PasswordChangePhase.success
            ? Colors.green
            : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
      ),
    );
  }

  // Build password dots (styled like splash page)
  Widget _buildPasswordDots(ThemeData theme, bool isDark) {
    final currentPassword = _currentPasswordForPhase;
    final passwordLength = currentPassword.length;
    final expectedLength = passwordLength == 0 ? 4 : passwordLength;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(expectedLength, (index) {
        final isFilled = index < passwordLength;
        final hasError = _errorMessage != null;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isFilled && !hasError
                  ? LinearGradient(colors: AppColors.getPrimaryGradient(isDark))
                  : null,
              border: Border.all(
                color: hasError
                    ? Colors.red.withValues(alpha: 0.5)
                    : isFilled
                    ? Colors.transparent
                    : (theme.textTheme.bodyLarge?.color ?? Colors.grey)
                          .withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }

  // Build loading indicator (styled like splash page)
  Widget _buildLoadingIndicator(ThemeData theme, bool isDark) {
    String loadingText;
    switch (_currentPhase) {
      case PasswordChangePhase.currentPassword:
        loadingText = 'Verifying current password...';
        break;
      case PasswordChangePhase.confirmPassword:
        loadingText = 'Changing password...';
        break;
      default:
        loadingText = 'Processing...';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          loadingText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Build numeric keypad
  Widget _buildNumericKeypad() {
    return NumericKeypad(
      onNumberPressed: _onNumberPressed,
      onDeletePressed: _onDeletePressed,
      enabled: !_isLoading,
    );
  }
}
