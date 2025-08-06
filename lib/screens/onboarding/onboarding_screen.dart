import 'package:diaryx/widgets/annotated_region/system_ui_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/premium_button/premium_button.dart';
import '../../widgets/numeric_keypad/numeric_keypad.dart';
import '../../themes/app_colors.dart';
import '../../stores/auth_store.dart';
import '../../stores/onboarding_store.dart';

import '../../routes.dart';
import '../../utils/app_logger.dart';

/// Onboarding screen with 5 pages
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _password = '';
  bool _isPasswordSetup = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: PremiumAnimations.normal,
        curve: PremiumAnimations.easeOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    AppLogger.info('Onboarding completed');

    // Mark onboarding as completed
    final onboardingStore = Provider.of<OnboardingStore>(
      context,
      listen: false,
    );
    await onboardingStore.completeOnboarding();

    if (mounted) {
      AppRoutes.toHome(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: PremiumScreenBackground(
          child: SafeArea(
            child: Column(
              children: [
                // Progress indicators
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => AnimatedContainer(
                        duration: PremiumAnimations.fast,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                              : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary)
                                    .withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return _buildWelcomePage();
                        case 1:
                          return _buildCapturePage();
                        case 2:
                          return _buildPasswordPage();
                        case 3:
                          return _buildAIPage();
                        case 4:
                          return _buildCompletePage();
                        default:
                          return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return FadeInSlideUp(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo with floating animation
            FloatingAnimation(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightPrimary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/logo_macos.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Main message
            Text(
              'Your Memories, Your Secrets',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.displayMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Private. Offline. Yours alone.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            const Spacer(),

            // CTA Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: PremiumButton(
                text: 'Begin Journey',
                onPressed: _nextPage,
                icon: Icons.arrow_forward_rounded,
                isIconFirst: false,
                width: 200,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapturePage() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeInSlideUp(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 1),

            // Hero Title Section
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: Column(
                children: [
                  // Main title with gradient text effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.lightPrimary, AppColors.lightAccent],
                    ).createShader(bounds),
                    child: Text(
                      'Capture Life',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your way, enhanced by AI',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.7,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Main Capture Hub
            Expanded(
              flex: 3,
              child: FadeInSlideUp(
                delay: const Duration(milliseconds: 300),
                child: _buildModernCaptureHub(),
              ),
            ),

            const SizedBox(height: 32),

            // AI Features Showcase
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: _buildAIFeaturesShowcase(theme, isDark),
            ),

            const SizedBox(height: 32),

            // Privacy Assurance
            FadeInSlideUp(
              delay: const Duration(milliseconds: 500),
              child: _buildPrivacyAssurance(theme),
            ),

            const Spacer(flex: 1),

            // Next Button
            FadeInSlideUp(
              delay: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: PremiumButton(
                  text: 'Get Started',
                  onPressed: _nextPage,
                  icon: Icons.arrow_forward_rounded,
                  isIconFirst: false,
                  width: 200,
                  height: 56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordPage() {
    return Consumer<AuthStore>(
      builder: (context, authStore, _) => FadeInSlideUp(
        delay: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Title
              Text(
                'Secure Your Memories',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Set 4-6 digit passcode',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Premium password dots
              _buildPremiumPasswordDots(
                length: _password.length,
                hasError: authStore.error != null,
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),

              if (authStore.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  authStore.error!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: 40),

              // Numeric keypad
              NumericKeypad(
                onNumberPressed: (number) {
                  if (_password.length < 6) {
                    setState(() {
                      _password += number;
                    });
                  }
                },
                onDeletePressed: () {
                  if (_password.isNotEmpty) {
                    setState(() {
                      _password = _password.substring(0, _password.length - 1);
                    });
                  }
                },
                enabled: !authStore.isLoading,
              ),

              const Spacer(),

              // Action buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    if (_password.length >= 4)
                      PremiumButton(
                        text: authStore.isLoading
                            ? 'Setting Password...'
                            : 'Set Password',
                        onPressed: authStore.isLoading
                            ? null
                            : () async {
                                final success = await authStore.setupPassword(
                                  _password,
                                );
                                if (success) {
                                  setState(() {
                                    _isPasswordSetup = true;
                                  });
                                  _nextPage();
                                }
                              },
                        width: 200,
                        height: 56,
                      ),

                    const SizedBox(height: 16),

                    // Skip button
                    TextButton(
                      onPressed: () async {
                        final onboardingStore = Provider.of<OnboardingStore>(
                          context,
                          listen: false,
                        );
                        await onboardingStore.skipPasswordSetup();
                        _nextPage();
                      },
                      child: Text(
                        'Skip for Now',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                    ),

                    if (!_isPasswordSetup) ...[
                      const SizedBox(height: 8),
                      Text(
                        'You can add security later in settings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIPage() {
    final theme = Theme.of(context);

    return FadeInSlideUp(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // AI Icon
            FadeInSlideUp(
              delay: const Duration(milliseconds: 200),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.lightAccent, AppColors.lightPrimary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightAccent.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            FadeInSlideUp(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Unlock AI Features',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            FadeInSlideUp(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Run Gemma 3n model with Google AI Edge or Ollama engines for personalized insights and intelligent conversations.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 48),

            const Spacer(),

            // Setup options
            FadeInSlideUp(
              delay: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  // Setup AI button
                  PremiumButton(
                    text: 'Set Up AI Model',
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.aiModel),
                    icon: Icons.settings_rounded,
                    width: 220,
                    height: 56,
                  ),

                  const SizedBox(height: 20),

                  // Skip option
                  GestureDetector(
                    onTap: () async {
                      final onboardingStore = Provider.of<OnboardingStore>(
                        context,
                        listen: false,
                      );
                      await onboardingStore.skipAISetup();
                      _nextPage();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: theme.colorScheme.surface.withValues(alpha: 0.5),
                        border: Border.all(
                          color: theme.colorScheme.outline.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Skip (some features will be disabled)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.6,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletePage() {
    return FadeInSlideUp(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Celebration animation
            ScaleInBounce(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: AppColors.getPrimaryGradient(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightPrimary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 50)),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              'Welcome Home',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Message
            Text(
              'Your private sanctuary awaits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Start button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: PremiumButton(
                text: 'Start Capturing',
                onPressed: _finishOnboarding,
                icon: Icons.rocket_launch,
                isIconFirst: false,
                width: 220,
                height: 56,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Premium password dots display (similar to splash screen)
  Widget _buildPremiumPasswordDots({
    required int length,
    required bool hasError,
    required bool isDark,
    int? expectedLength,
  }) {
    // Dynamically calculate the number of dots to display
    final displayLength =
        expectedLength ??
        (length == 0 ? 4 : (length < 4 ? 4 : (length > 6 ? 6 : length)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(displayLength, (index) {
        final isFilled = index < length;
        final isError = hasError;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isFilled
                ? (isError
                      ? LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.red.withValues(alpha: 0.7),
                          ],
                        )
                      : LinearGradient(
                          colors: AppColors.getPrimaryGradient(isDark),
                        ))
                : null,
            color: !isFilled
                ? (isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1))
                : null,
            border: isDark
                ? Border.all(
                    color: isFilled
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color:
                          (isError
                                  ? Colors.red
                                  : (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary))
                              .withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  /// Clean capture methods without container
  Widget _buildModernCaptureHub() {
    return Row(
      children: [
        // Voice
        Expanded(
          child: _buildCleanCaptureCard(
            icon: Icons.mic_rounded,
            title: 'Voice',
            color: const Color(0xFF667EEA),
          ),
        ),
        const SizedBox(width: 16),

        // Camera (same size as others)
        Expanded(
          child: _buildCleanCaptureCard(
            icon: Icons.camera_alt_rounded,
            title: 'Camera',
            color: const Color(0xFFFF6B6B),
          ),
        ),
        const SizedBox(width: 16),

        // Text
        Expanded(
          child: _buildCleanCaptureCard(
            icon: Icons.edit_rounded,
            title: 'Text',
            color: const Color(0xFF4ECDC4),
          ),
        ),
      ],
    );
  }

  /// Clean capture card with equal size
  Widget _buildCleanCaptureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      height: 100, // Slightly taller for better proportions
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// AI Features Showcase with modern design
  Widget _buildAIFeaturesShowcase(ThemeData theme, bool isDark) {
    return Column(
      children: [
        // AI Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                AppColors.lightPrimary.withValues(alpha: 0.15),
                AppColors.lightAccent.withValues(alpha: 0.15),
              ],
            ),
            border: Border.all(
              color: AppColors.lightPrimary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('✨', style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'AI-Powered Intelligence',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // AI Features in flowing layout
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _buildFlowingAIFeature('📊', 'Mood Analysis'),
            _buildFlowingAIFeature('🔍', 'Smart Search'),
            _buildFlowingAIFeature('💬', 'AI Conversations'),
            _buildFlowingAIFeature('📈', 'Insights'),
            _buildFlowingAIFeature('🏷️', 'Tag Management'),
            _buildFlowingAIFeature('🛡️', 'Privacy Protection'),
          ],
        ),
      ],
    );
  }

  /// Flowing AI feature chip
  Widget _buildFlowingAIFeature(String emoji, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Privacy assurance with modern design
  Widget _buildPrivacyAssurance(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.success.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: AppColors.success,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Privacy First',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'All AI processing happens on your device',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
