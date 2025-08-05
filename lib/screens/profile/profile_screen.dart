import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../stores/theme_store.dart';
import '../../utils/app_logger.dart';
import '../../consts/env_config.dart';
import '../../themes/app_colors.dart';
import '../../routes.dart';

part 'profile_header.dart';
part 'profile_settings.dart';

/// Profile screen for settings and user preferences
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Profile screen opened');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: 100,
            top: MediaQuery.of(context).padding.top + 24,
          ),
          child: Column(
            children: [
              // Premium welcome header with geometric design
              FadeInSlideUp(child: _PremiumWelcomeHeader()),
              const SizedBox(height: 32),

              // Premium Settings sections with staggered animations
              StaggeredAnimationContainer(
                staggerDelay: const Duration(milliseconds: 100),
                children: [
                  _PremiumSettingsSection(
                    title: 'Appearance',
                    icon: Icons.palette_rounded,
                    items: [
                      Consumer<ThemeStore>(
                        builder: (context, themeStore, child) {
                          return _PremiumSettingsItem(
                            icon: Icons.brightness_6_rounded,
                            title: 'Theme',
                            subtitle:
                                'Current: ${themeStore.currentThemeDisplayName}',
                            onTap: () {
                              AppLogger.userAction('Theme settings opened');
                              _showThemeDialog(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  _PremiumSettingsSection(
                    title: 'AI Preferences',
                    icon: Icons.psychology_rounded,
                    items: [
                      _PremiumSettingsItem(
                        icon: Icons.smart_toy_rounded,
                        title: 'AI Model',
                        subtitle: 'Local model vs Remote API',
                        onTap: () {
                          AppLogger.userAction('AI model settings opened');
                          _showComingSoon(context, 'AI Model Settings');
                        },
                      ),
                      _PremiumSettingsItem(
                        icon: Icons.auto_awesome_rounded,
                        title: 'AI Features',
                        subtitle: 'Configure AI assistance',
                        onTap: () {
                          AppLogger.userAction('AI features settings opened');
                          _showComingSoon(context, 'AI Features');
                        },
                      ),
                    ],
                  ),

                  _PremiumSettingsSection(
                    title: 'Privacy & Security',
                    icon: Icons.shield_rounded,
                    items: [
                      _PremiumSettingsItem(
                        icon: Icons.lock_rounded,
                        title: 'Change Password',
                        subtitle: 'Update your numeric password',
                        onTap: () {
                          AppLogger.userAction('Change password requested');
                          _showComingSoon(context, 'Password Change');
                        },
                      ),
                    ],
                  ),

                  _PremiumSettingsSection(
                    title: 'About',
                    icon: Icons.info_rounded,
                    items: [
                      _PremiumSettingsItem(
                        icon: Icons.article_rounded,
                        title: 'About DiaryX',
                        subtitle: 'Version 1.0.0',
                        onTap: () {
                          AppLogger.userAction('About app viewed');
                          _showAboutDialog(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: Text('$feature will be available in future updates.'),
        actions: [
          TextButton(
            onPressed: () => AppRoutes.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeStore = Provider.of<ThemeStore>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              trailing: themeStore.themeMode == ThemeMode.light
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                AppRoutes.pop(context);
                themeStore.setThemeMode(ThemeMode.light);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              trailing: themeStore.themeMode == ThemeMode.dark
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                AppRoutes.pop(context);
                themeStore.setThemeMode(ThemeMode.dark);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_system_daydream),
              title: const Text('System'),
              trailing: themeStore.themeMode == ThemeMode.system
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                AppRoutes.pop(context);
                themeStore.setThemeMode(ThemeMode.system);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      AppLogger.error('Could not launch $url');
    }
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Stack(
            children: [
              // Main content
              PremiumGlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // App Logo with premium styling
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                    .withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/logo_macos.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // App Name with gradient text
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ).createShader(bounds),
                      child: Text(
                        EnvConfig.appName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Version with premium styling
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.getPrimaryGradient(isDark),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Version 1.0.0',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Author info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.code_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Created by xalanq',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'A private, offline-first diary application with AI-powered features.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Built with Flutter and designed for privacy.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Project Homepage Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _launchURL('https://github.com/xalanq/DiaryX'),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.getPrimaryGradient(isDark)
                                  .map((color) => color.withValues(alpha: 0.1))
                                  .toList(),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary)
                                      .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.open_in_new_rounded,
                                size: 20,
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'View on GitHub',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Close button in top right corner
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => AppRoutes.pop(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
