import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/error_states/error_states.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/premium_button/premium_button.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../stores/moment_store.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

/// Timeline screen showing chronological moment view with calendar mode
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isCalendarMode = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Timeline screen opened');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MomentStore>().loadMoments();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: Column(
          children: [
            // Premium App Bar with glass morphism
            _PremiumTimelineAppBar(
              isCalendarMode: _isCalendarMode,
              onViewModeChanged: () {
                setState(() {
                  _isCalendarMode = !_isCalendarMode;
                });
                AppLogger.userAction('Timeline view changed', {
                  'mode': _isCalendarMode ? 'calendar' : 'list',
                });
              },
              onFilterPressed: () {
                AppLogger.userAction('Timeline filter opened');
                // TODO: Implement filter bottom sheet
              },
            ),

            // Content with premium styling
            Expanded(
              child: Consumer<MomentStore>(
                builder: (context, momentStore, child) {
                  if (momentStore.isLoading && momentStore.moments.isEmpty) {
                    return const _PremiumTimelineLoadingState();
                  }

                  if (momentStore.error != null) {
                    return FadeInSlideUp(
                      child: ErrorState(
                        title: 'Failed to Load Moments',
                        message: momentStore.error,
                        onAction: () => momentStore.loadMoments(),
                      ),
                    );
                  }

                  if (momentStore.moments.isEmpty) {
                    return _PremiumNoMomentsState(
                      onCreateMoment: () {
                        AppLogger.userAction(
                          'Create moment from empty timeline',
                        );
                        // TODO: Navigate to capture screen
                      },
                    );
                  }

                  return _isCalendarMode
                      ? _PremiumCalendarView(moments: momentStore.moments)
                      : _PremiumListView(moments: momentStore.moments);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Premium app bar for timeline
class _PremiumTimelineAppBar extends StatelessWidget {
  final bool isCalendarMode;
  final VoidCallback onViewModeChanged;
  final VoidCallback onFilterPressed;

  const _PremiumTimelineAppBar({
    required this.isCalendarMode,
    required this.onViewModeChanged,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      child: PremiumGlassCard(
        borderRadius: 24,
        hasGradient: true,
        gradientColors: isDark
            ? [
                AppColors.darkSurface.withValues(alpha: 0.9),
                AppColors.darkSurface.withValues(alpha: 0.7),
              ]
            : [
                AppColors.lightSurface.withValues(alpha: 0.95),
                AppColors.lightSurface.withValues(alpha: 0.85),
              ],
        child: Row(
          children: [
            // Title with geometric accent
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Timeline',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            PremiumIconButton(
              icon: isCalendarMode
                  ? Icons.view_list_rounded
                  : Icons.calendar_month_rounded,
              onPressed: onViewModeChanged,
              hasGlow: true,
            ),
            const SizedBox(width: 12),
            PremiumIconButton(
              icon: Icons.tune_rounded,
              onPressed: onFilterPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumTimelineLoadingState extends StatelessWidget {
  const _PremiumTimelineLoadingState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StaggeredAnimationContainer(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ShimmerLoading(
              child: PremiumGlassCard(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium no moments state
class _PremiumNoMomentsState extends StatelessWidget {
  final VoidCallback onCreateMoment;

  const _PremiumNoMomentsState({required this.onCreateMoment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              kBottomNavigationBarHeight -
              120, // AppBar and padding
        ),
        child: Center(
          child: FadeInSlideUp(
            child: Padding(
              padding: EdgeInsets.only(top: 40, bottom: 120),
              child: PremiumGlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No Moments Yet',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Start your journaling journey by creating your first moment.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: 0.7,
                        ),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    PremiumButton(
                      text: 'Create Moment',
                      icon: Icons.add_rounded,
                      onPressed: onCreateMoment,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumListView extends StatelessWidget {
  final List<dynamic> moments; // Will be List<MomentData> when properly typed

  const _PremiumListView({required this.moments});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        AppLogger.userAction('Timeline pull to refresh');
        await context.read<MomentStore>().loadMoments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100, top: 16), // Space for FAB
        itemCount: moments.length,
        itemBuilder: (context, index) {
          return FadeInSlideUp(
            delay: Duration(milliseconds: index * 100),
            child: _PremiumMomentListItem(moment: moments[index], index: index),
          );
        },
      ),
    );
  }
}

class _PremiumCalendarView extends StatelessWidget {
  final List<dynamic> moments;

  const _PremiumCalendarView({required this.moments});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Premium Calendar header
        Padding(
          padding: const EdgeInsets.all(20),
          child: PremiumGlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PremiumIconButton(
                  icon: Icons.chevron_left_rounded,
                  onPressed: () {
                    AppLogger.userAction('Calendar previous month');
                  },
                ),
                Text(
                  'January 2024', // TODO: Make dynamic
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                PremiumIconButton(
                  icon: Icons.chevron_right_rounded,
                  onPressed: () {
                    AppLogger.userAction('Calendar next month');
                  },
                ),
              ],
            ),
          ),
        ),

        // Premium Calendar placeholder with enhanced styling
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PremiumGlassCard(
              hasGradient: true,
              gradientColors: isDark
                  ? [
                      AppColors.darkSurface.withValues(alpha: 0.9),
                      AppColors.darkSurface.withValues(alpha: 0.6),
                    ]
                  : [
                      AppColors.lightSurface.withValues(alpha: 0.95),
                      AppColors.lightSurface.withValues(alpha: 0.8),
                    ],
              child: Center(
                child: FadeInSlideUp(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleInBounce(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                (isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary)
                                    .withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Calendar View',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Beautiful calendar interface coming soon',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PremiumPulseAnimation(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.getPrimaryGradient(isDark),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Phase 5',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

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
                      letterSpacing: 0.2,
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
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                letterSpacing: 0.1,
              ),
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
              letterSpacing: 0.2,
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
          letterSpacing: 0.2,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
