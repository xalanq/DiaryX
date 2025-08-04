import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      _PremiumSettingsItem(
                        icon: Icons.help_rounded,
                        title: 'Help & Support',
                        subtitle: 'Get help using the app',
                        onTap: () {
                          AppLogger.userAction('Help requested');
                          _showComingSoon(context, 'Help & Support');
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

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: EnvConfig.appName,
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.book, color: Colors.white, size: 32),
      ),
      children: [
        const Text(
          'A private, offline-first diary application with AI-powered features.',
        ),
        const SizedBox(height: 16),
        const Text('Built with Flutter and designed for privacy.'),
      ],
    );
  }
}
