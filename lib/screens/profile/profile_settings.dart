part of 'profile_screen.dart';

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
