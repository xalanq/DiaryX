import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/glass_card/glass_card.dart';
import '../../widgets/app_button/app_button.dart';
import '../../stores/auth_store.dart';
import '../../utils/app_logger.dart';
import '../../consts/env_config.dart';

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
      appBar: const CustomAppBar(title: 'Profile', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile header
            GlassCard(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to DiaryX',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your private diary companion',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings sections
            _SettingsSection(
              title: 'Privacy & Security',
              items: [
                _SettingsItem(
                  icon: Icons.lock,
                  title: 'Change Password',
                  subtitle: 'Update your numeric password',
                  onTap: () {
                    AppLogger.userAction('Change password requested');
                    _showComingSoon(context, 'Password Change');
                  },
                ),
                _SettingsItem(
                  icon: Icons.security,
                  title: 'Security Settings',
                  subtitle: 'Manage app security preferences',
                  onTap: () {
                    AppLogger.userAction('Security settings opened');
                    _showComingSoon(context, 'Security Settings');
                  },
                ),
              ],
            ),

            _SettingsSection(
              title: 'AI Preferences',
              items: [
                _SettingsItem(
                  icon: Icons.psychology,
                  title: 'AI Model',
                  subtitle: 'Local model vs Remote API',
                  onTap: () {
                    AppLogger.userAction('AI model settings opened');
                    _showComingSoon(context, 'AI Model Settings');
                  },
                ),
                _SettingsItem(
                  icon: Icons.auto_awesome,
                  title: 'AI Features',
                  subtitle: 'Configure AI assistance',
                  onTap: () {
                    AppLogger.userAction('AI features settings opened');
                    _showComingSoon(context, 'AI Features');
                  },
                ),
              ],
            ),

            _SettingsSection(
              title: 'Appearance',
              items: [
                _SettingsItem(
                  icon: Icons.palette,
                  title: 'Theme',
                  subtitle: 'Light, dark, or system',
                  onTap: () {
                    AppLogger.userAction('Theme settings opened');
                    _showThemeDialog(context);
                  },
                ),
                _SettingsItem(
                  icon: Icons.text_fields,
                  title: 'Text Size',
                  subtitle: 'Adjust reading comfort',
                  onTap: () {
                    AppLogger.userAction('Text size settings opened');
                    _showComingSoon(context, 'Text Size Settings');
                  },
                ),
              ],
            ),

            _SettingsSection(
              title: 'Data & Backup',
              items: [
                _SettingsItem(
                  icon: Icons.backup,
                  title: 'Export Data',
                  subtitle: 'Download your diary entries',
                  onTap: () {
                    AppLogger.userAction('Export data requested');
                    _showComingSoon(context, 'Data Export');
                  },
                ),
                _SettingsItem(
                  icon: Icons.storage,
                  title: 'Storage Usage',
                  subtitle: 'View app storage details',
                  onTap: () {
                    AppLogger.userAction('Storage usage viewed');
                    _showComingSoon(context, 'Storage Usage');
                  },
                ),
              ],
            ),

            _SettingsSection(
              title: 'About',
              items: [
                _SettingsItem(
                  icon: Icons.info,
                  title: 'About DiaryX',
                  subtitle: 'Version 1.0.0',
                  onTap: () {
                    AppLogger.userAction('About app viewed');
                    _showAboutDialog(context);
                  },
                ),
                _SettingsItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  subtitle: 'Get help using the app',
                  onTap: () {
                    AppLogger.userAction('Help requested');
                    _showComingSoon(context, 'Help & Support');
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Reset button
            Consumer<AuthStore>(
              builder: (context, authStore, child) {
                return AppButton(
                  text: 'Reset App Data',
                  type: AppButtonType.destructive,
                  size: AppButtonSize.full,
                  icon: Icons.restore,
                  onPressed: () {
                    _showResetDialog(context, authStore);
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // App info
            Text(
              '${EnvConfig.appName} v1.0.0\nBuilt with ❤️ for privacy',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),
          ],
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
              onTap: () {
                Navigator.of(context).pop();
                AppLogger.userAction('Theme changed', {'theme': 'light'});
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                Navigator.of(context).pop();
                AppLogger.userAction('Theme changed', {'theme': 'dark'});
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_system_daydream),
              title: const Text('System'),
              onTap: () {
                Navigator.of(context).pop();
                AppLogger.userAction('Theme changed', {'theme': 'system'});
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
              Theme.of(context).primaryColor.withOpacity(0.7),
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

  void _showResetDialog(BuildContext context, AuthStore authStore) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App Data'),
        content: const Text(
          'This will delete all your diary entries, settings, and reset the app to its initial state. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              AppLogger.userAction('App data reset confirmed');
              await authStore.resetAuth();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('App data has been reset')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  item,
                  if (!isLast) const Divider(height: 1, indent: 56),
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

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
