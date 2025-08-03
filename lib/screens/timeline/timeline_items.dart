part of 'timeline_screen.dart';

class _PremiumMomentListItem extends StatelessWidget {
  final dynamic moment; // Will be MomentData when properly typed
  final int index;

  const _PremiumMomentListItem({required this.moment, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: PremiumMomentCard(
        mood: 'happy', // TODO: Get actual mood from moment
        onTap: () {
          AppLogger.userAction('Moment tapped', {'index': index});
          // TODO: Navigate to moment detail
        },
        onLongPress: () {
          AppLogger.userAction('Moment long pressed', {'index': index});
          // TODO: Show moment options
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Moment header
            Row(
              children: [
                // Enhanced mood indicator with glow
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.getEmotionColor(
                          'happy',
                        ), // TODO: Use actual mood
                        AppColors.getEmotionColor(
                          'happy',
                        ).withValues(alpha: 0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.getEmotionColor(
                          'happy',
                        ).withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Time with enhanced styling
                Expanded(
                  child: Text(
                    'Today, 2:30 PM', // TODO: Format actual date
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Premium content type badge
                _PremiumContentTypeBadge(
                  type: 'Text', // TODO: Show actual content type
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Moment content preview with enhanced styling
            Text(
              'Sample moment content that would be displayed here with beautiful typography and proper spacing...', // TODO: Show actual content
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Divider
            Divider(
              height: 1,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),

            const SizedBox(height: 16),

            // Premium tags with enhanced styling
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _PremiumTagChip(label: 'personal', isDark: isDark),
                _PremiumTagChip(label: 'reflection', isDark: isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium content type badge
class _PremiumContentTypeBadge extends StatelessWidget {
  final String type;
  final bool isDark;

  const _PremiumContentTypeBadge({required this.type, required this.isDark});

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return Icons.text_fields_rounded;
      case 'voice':
        return Icons.mic_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'video':
        return Icons.videocam_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return Colors.blue;
      case 'voice':
        return Colors.green;
      case 'image':
        return Colors.orange;
      case 'video':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(type);
    final icon = _getIconForType(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            type,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium tag chip with enhanced styling
class _PremiumTagChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _PremiumTagChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.darkSurface.withValues(alpha: 0.8),
                  AppColors.darkSurface.withValues(alpha: 0.6),
                ]
              : [
                  AppColors.lightSurface.withValues(alpha: 0.9),
                  AppColors.lightSurface.withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '#$label',
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
