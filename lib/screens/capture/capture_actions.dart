part of 'capture_screen.dart';

/// Premium quick actions section
class _PremiumQuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
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
                  Icons.flash_on_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkPrimary
                      : AppColors.lightPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick action items
          _PremiumQuickActionItem(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Suggested Prompt',
            subtitle: 'Get inspiration for today\'s moment',
            onTap: () {
              AppLogger.userAction('AI prompt requested');
              _showComingSoon(context, 'AI Prompts');
            },
          ),
          _buildDivider(isDark),
          _PremiumQuickActionItem(
            icon: Icons.mood_rounded,
            title: 'Mood Check-in',
            subtitle: 'Quick mood tracking',
            onTap: () {
              AppLogger.userAction('Mood check-in selected');
              _showComingSoon(context, 'Mood Tracking');
            },
          ),
          _buildDivider(isDark),
          _PremiumQuickActionItem(
            icon: Icons.today_rounded,
            title: 'Daily Reflection',
            subtitle: 'Guided reflection questions',
            onTap: () {
              AppLogger.userAction('Daily reflection selected');
              _showComingSoon(context, 'Daily Reflection');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        indent: 50,
        endIndent: 20,
        height: 1,
        color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
            .withValues(alpha: 0.2),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    HapticFeedback.lightImpact();

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
}

/// Premium quick action item
class _PremiumQuickActionItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PremiumQuickActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_PremiumQuickActionItem> createState() =>
      _PremiumQuickActionItemState();
}

class _PremiumQuickActionItemState extends State<_PremiumQuickActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
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
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    // Enhanced icon
                    Container(
                      width: 40,
                      height: 40,
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 20,
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
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

                    // Chevron
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.5,
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

/// Premium recent moments section
class _PremiumRecentMoments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PremiumGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Recent Moments',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  AppLogger.userAction('View all moments from capture');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Empty state with beautiful design
          Center(
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface)
                            .withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_outlined,
                    size: 28,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No recent moments',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Start capturing your thoughts',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.5,
                    ),
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
