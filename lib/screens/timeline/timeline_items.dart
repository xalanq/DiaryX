part of 'timeline_screen.dart';

class _PremiumMomentListItem extends StatelessWidget {
  final Moment moment;
  final int index;

  const _PremiumMomentListItem({required this.moment, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: PremiumMomentCard(
        mood: moment.moods.firstOrNull,
        onTap: () {
          AppLogger.userAction('Moment tapped', {'momentId': moment.id});
          // Navigate to edit moment
          AppRoutes.toTextMoment(context, existingMoment: moment);
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
                        MoodColors.getMoodColor(moment.moods.firstOrNull),
                        MoodColors.getMoodColor(
                          moment.moods.firstOrNull,
                        ).withValues(alpha: 0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: MoodColors.getMoodColor(
                          moment.moods.firstOrNull,
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
                    _formatDate(moment.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Premium content type badge
                _PremiumContentTypeBadge(
                  type: _getContentType(moment),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Moment content preview with enhanced styling
            Text(
              moment.content,
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

  String _getContentType(Moment moment) {
    final hasImages = moment.images.isNotEmpty;
    final hasAudios = moment.audios.isNotEmpty;
    final hasVideos = moment.videos.isNotEmpty;
    final hasText = moment.content.isNotEmpty;

    final mediaCount =
        (hasImages ? 1 : 0) + (hasAudios ? 1 : 0) + (hasVideos ? 1 : 0);

    if (mediaCount > 1) {
      return 'mixed';
    } else if (hasImages) {
      return 'image';
    } else if (hasAudios) {
      return 'audio';
    } else if (hasVideos) {
      return 'video';
    } else if (hasText) {
      return 'text';
    } else {
      return 'text';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final momentDate = DateTime(date.year, date.month, date.day);

    if (momentDate == today) {
      return 'Today, ${_formatTime(date)}';
    } else if (momentDate == yesterday) {
      return 'Yesterday, ${_formatTime(date)}';
    } else if (now.difference(date).inDays < 7) {
      return '${_getDayName(date.weekday)}, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
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
      case 'audio':
        return Icons.mic_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'video':
        return Icons.videocam_rounded;
      case 'mixed':
        return Icons.collections_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return Colors.blue;
      case 'audio':
        return Colors.green;
      case 'image':
        return Colors.orange;
      case 'video':
        return Colors.purple;
      case 'mixed':
        return Colors.indigo;
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
