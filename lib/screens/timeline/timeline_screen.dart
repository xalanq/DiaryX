import 'dart:io';
import 'package:diaryx/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../consts/env_config.dart';
import '../../widgets/error_states/error_states.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/premium_button/premium_button.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/audio_recorder/audio_player.dart';
import '../../widgets/image_preview/premium_image_preview.dart';
import '../../stores/moment_store.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../models/moment.dart';
import '../../models/mood.dart';
import '../../models/media_attachment.dart';

part 'timeline_items.dart';
part 'timeline_states.dart';

part 'timeline_core.dart';
part 'timeline_date_separator.dart';
part 'timeline_calendar.dart';

/// Timeline item types for unified list display
enum TimelineItemType { moment, dateSeparator }

/// Timeline item data class for unified list structure
class TimelineItem {
  final TimelineItemType type;
  final Moment? moment;
  final DateTime? date;
  final String? dateLabel;
  final int momentCount;

  const TimelineItem.moment(this.moment)
    : type = TimelineItemType.moment,
      date = null,
      dateLabel = null,
      momentCount = 0;

  const TimelineItem.dateSeparator({
    required this.date,
    required this.dateLabel,
    required this.momentCount,
  }) : type = TimelineItemType.dateSeparator,
       moment = null;
}

/// Timeline screen displaying chronological moment view with calendar functionality
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  List<TimelineItem> _timelineItems = [];

  // Track expanded state for each moment by ID
  final Map<int, bool> _expandedStates = {};
  // Track image expanded state for each moment by ID
  final Map<int, bool> _imagesExpandedStates = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    AppLogger.userAction('Timeline screen opened');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MomentStore>().loadMoments();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<TimelineItem> _buildTimelineItems(List<Moment> moments) {
    final items = <TimelineItem>[];

    if (moments.isEmpty) {
      return [];
    }

    final momentsByDate = <String, List<Moment>>{};

    // Group moments by date for organization
    for (final moment in moments) {
      final dateKey = _formatDateKey(moment.createdAt);
      momentsByDate.putIfAbsent(dateKey, () => []).add(moment);
    }

    // Sort dates in descending order (newest first)
    final sortedDates = momentsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final dateKey in sortedDates) {
      final dayMoments = momentsByDate[dateKey]!
        ..sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        ); // Sort moments within day by newest first

      // Create date separator for this date
      final date = DateTime.parse(dateKey);
      final dateLabel = _formatDateLabel(date);
      items.add(
        TimelineItem.dateSeparator(
          date: date,
          dateLabel: dateLabel,
          momentCount: dayMoments.length,
        ),
      );

      // Add moments for this date
      for (final moment in dayMoments) {
        items.add(TimelineItem.moment(moment));
      }
    }

    return items;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else if (targetDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      if (now.difference(date).inDays < 7 && now.difference(date).inDays > 0) {
        return weekdays[date.weekday - 1];
      } else {
        return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
      }
    }
  }

  void _scrollToDate(DateTime date) {
    // Find the index of the date separator for this date
    final dateKey = _formatDateKey(date);
    int targetIndex = -1;

    for (int i = 0; i < _timelineItems.length; i++) {
      final item = _timelineItems[i];
      if (item.type == TimelineItemType.dateSeparator && item.date != null) {
        final itemDateKey = _formatDateKey(item.date!);
        if (itemDateKey == dateKey) {
          targetIndex = i;
          break;
        }
      }
    }

    if (targetIndex >= 0 && _scrollController.hasClients) {
      // Estimate scroll position based on item index
      final estimatedPosition = targetIndex * 200.0; // Rough estimate
      _scrollController.animateTo(
        estimatedPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showDatePicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return _CalendarDropdownModal(
          onDateSelected: (date) {
            _scrollToDate(date);
            Navigator.of(context).pop();
          },
          moments: context.read<MomentStore>().moments,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: Consumer<MomentStore>(
          builder: (context, momentStore, child) {
            // Build timeline items when moments data changes
            _timelineItems = _buildTimelineItems(momentStore.moments);

            final padding = MediaQuery.paddingOf(context);
            final viewPadding = MediaQuery.viewPaddingOf(context);

            return GestureDetector(
              onTap: () {
                // Clear text selection when tapping outside
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: EdgeInsets.only(top: padding.top),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    if (momentStore.isLoading &&
                        momentStore.moments.isEmpty) ...[
                      SliverToBoxAdapter(
                        child: _StickyDateSeparatorCard(
                          dateLabel: 'Timeline',
                          momentCount: 0,
                          onCalendarTap: () {},
                        ),
                      ),
                      // Loading state display
                      SliverFillRemaining(
                        child: const _PremiumTimelineLoadingState(),
                      ),
                    ] else if (momentStore.error != null) ...[
                      SliverToBoxAdapter(
                        child: _StickyDateSeparatorCard(
                          dateLabel: 'Timeline',
                          momentCount: 0,
                          onCalendarTap: () {},
                        ),
                      ),
                      // Error state display
                      SliverFillRemaining(
                        child: FadeInSlideUp(
                          child: ErrorState(
                            title: 'Failed to Load Moments',
                            message: momentStore.error,
                            onAction: () => momentStore.loadMoments(),
                          ),
                        ),
                      ),
                    ] else if (momentStore.moments.isEmpty) ...[
                      SliverToBoxAdapter(
                        child: _StickyDateSeparatorCard(
                          dateLabel: 'Timeline',
                          momentCount: 0,
                          onCalendarTap: () {},
                        ),
                      ),
                      // Empty state display
                      SliverFillRemaining(
                        child: _PremiumNoMomentsState(
                          onCreateMoment: () {
                            AppRoutes.toCapture(context);
                          },
                        ),
                      ),
                    ] else ...[
                      _StickyTimelineSliver(
                        timelineItems: _timelineItems,
                        onCalendarTap: _showDatePicker,
                        expandedStates: _expandedStates,
                        onExpandedChanged: (momentId, isExpanded) {
                          setState(() {
                            _expandedStates[momentId] = isExpanded;
                          });
                        },
                        imagesExpandedStates: _imagesExpandedStates,
                        onImagesExpandedChanged: (momentId, isExpanded) {
                          setState(() {
                            _imagesExpandedStates[momentId] = isExpanded;
                          });
                        },
                      ),
                    ],

                    // Bottom padding for floating navigation bar
                    SliverToBoxAdapter(
                      child: SizedBox(height: 90 + viewPadding.bottom + 20),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
