import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../stores/theme_store.dart';
import '../../utils/app_logger.dart';
import '../../consts/env_config.dart';
import '../../themes/app_colors.dart';

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
            onPressed: () => Navigator.of(context).pop(),
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
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
                Navigator.of(context).pop();
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

/// Premium welcome header with enhanced geometric design
class _PremiumWelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      hasGradient: true,
      gradientColors: isDark
          ? [
              AppColors.darkSurface.withValues(alpha: 0.8),
              AppColors.darkSurface.withValues(alpha: 0.4),
            ]
          : [
              AppColors.lightSurface.withValues(alpha: 0.9),
              AppColors.lightSurface.withValues(alpha: 0.6),
            ],
      child: Column(
        children: [
          // Compact geometric design
          ScaleInBounce(
            delay: const Duration(milliseconds: 200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background glow effect
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                // Main icon container with compact design
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                // Floating accent dots
                Positioned(
                  top: 8,
                  right: 12,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? AppColors.darkAccent
                                  : AppColors.lightAccent)
                              .withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          (isDark
                                  ? AppColors.darkSecondary
                                  : AppColors.lightSecondary)
                              .withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Compact title with version
          FadeInSlideUp(
            delay: const Duration(milliseconds: 400),
            child: Column(
              children: [
                Text(
                  'Welcome to DiaryX',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'v1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.getPrimaryGradient(isDark),
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Compact subtitle
          FadeInSlideUp(
            delay: const Duration(milliseconds: 600),
            child: Text(
              'Your personal space for memories,\nthoughts, and AI-powered insights',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium settings section with enhanced styling
class _PremiumSettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> items;

  const _PremiumSettingsSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                          .withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        PremiumGlassCard(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.zero,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Column(
                children: [
                  item,
                  if (!isLast)
                    Divider(
                      indent: 60,
                      endIndent: 20,
                      height: 1,
                      color:
                          (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.2),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Premium settings item with enhanced interactions
class _PremiumSettingsItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PremiumSettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_PremiumSettingsItem> createState() => _PremiumSettingsItemState();
}

class _PremiumSettingsItemState extends State<_PremiumSettingsItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              borderRadius: BorderRadius.circular(16),
              splashColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.05,
              ),
              highlightColor: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.03,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Enhanced icon container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.1),
                            (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                                .withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 22,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.7),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Enhanced chevron
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            (isDark
                                    ? AppColors.darkSurface
                                    : AppColors.lightSurface)
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
