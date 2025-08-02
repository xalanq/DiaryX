import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/glass_card/glass_card.dart';
import '../../widgets/main_layout/main_layout.dart';
import '../../utils/app_logger.dart';

/// Capture screen for quick entry creation
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Capture screen opened');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Capture',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'What\'s on your mind?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you\'d like to capture your thoughts today.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    icon: Icons.mic,
                    title: 'Voice',
                    subtitle: 'Record audio',
                    onTap: () {
                      AppLogger.userAction('Voice capture selected');
                      _showComingSoon(context, 'Voice Recording');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionCard(
                    icon: Icons.camera_alt,
                    title: 'Photo',
                    subtitle: 'Take a picture',
                    onTap: () {
                      AppLogger.userAction('Photo capture selected');
                      _showComingSoon(context, 'Photo Capture');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    icon: Icons.edit,
                    title: 'Text',
                    subtitle: 'Write it down',
                    onTap: () {
                      AppLogger.userAction('Text capture selected');
                      _showComingSoon(context, 'Text Entry');
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionCard(
                    icon: Icons.videocam,
                    title: 'Video',
                    subtitle: 'Record moment',
                    onTap: () {
                      AppLogger.userAction('Video capture selected');
                      _showComingSoon(context, 'Video Recording');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick actions
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _QuickActionTile(
                    icon: Icons.auto_awesome,
                    title: 'AI Suggested Prompt',
                    subtitle: 'Get inspiration for today\'s entry',
                    onTap: () {
                      AppLogger.userAction('AI prompt requested');
                      _showComingSoon(context, 'AI Prompts');
                    },
                  ),
                  const Divider(),
                  _QuickActionTile(
                    icon: Icons.mood,
                    title: 'Mood Check-in',
                    subtitle: 'Quick mood tracking',
                    onTap: () {
                      AppLogger.userAction('Mood check-in selected');
                      _showComingSoon(context, 'Mood Tracking');
                    },
                  ),
                  const Divider(),
                  _QuickActionTile(
                    icon: Icons.today,
                    title: 'Daily Reflection',
                    subtitle: 'Guided reflection questions',
                    onTap: () {
                      AppLogger.userAction('Daily reflection selected');
                      _showComingSoon(context, 'Daily Reflection');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent entries preview
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Entries',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          AppLogger.userAction('View all entries from capture');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No recent entries',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    QuickActionsBottomSheet.show(context, [
      QuickAction(
        title: 'Coming Soon',
        subtitle: '$feature will be available in future updates',
        icon: Icons.upcoming,
        onTap: () {},
      ),
    ]);
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
