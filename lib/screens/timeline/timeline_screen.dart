import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_app_bar/custom_app_bar.dart';
import '../../widgets/error_states/error_states.dart';
import '../../widgets/loading_states/loading_states.dart';
import '../../widgets/glass_card/glass_card.dart';
import '../../stores/moment_store.dart';
import '../../utils/app_logger.dart';

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
      appBar: CustomAppBar(
        title: 'Timeline',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(
              _isCalendarMode ? Icons.view_list : Icons.calendar_month,
            ),
            tooltip: _isCalendarMode ? 'List View' : 'Calendar View',
            onPressed: () {
              setState(() {
                _isCalendarMode = !_isCalendarMode;
              });
              AppLogger.userAction('Timeline view changed', {
                'mode': _isCalendarMode ? 'calendar' : 'list',
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () {
              AppLogger.userAction('Timeline filter opened');
              // TODO: Implement filter bottom sheet
            },
          ),
        ],
      ),
      body: Consumer<MomentStore>(
        builder: (context, momentStore, child) {
          if (momentStore.isLoading && momentStore.moments.isEmpty) {
            return const _TimelineLoadingState();
          }

          if (momentStore.error != null) {
            return ErrorState(
              title: 'Failed to Load Moments',
              message: momentStore.error,
              onAction: () => momentStore.loadMoments(),
            );
          }

          if (momentStore.moments.isEmpty) {
            return NoMomentsState(
              onCreateMoment: () {
                AppLogger.userAction('Create moment from empty timeline');
                // TODO: Navigate to capture screen
              },
            );
          }

          return _isCalendarMode
              ? _CalendarView(moments: momentStore.moments)
              : _ListView(moments: momentStore.moments);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppLogger.userAction('Create moment from timeline FAB');
          // TODO: Navigate to capture screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TimelineLoadingState extends StatelessWidget {
  const _TimelineLoadingState();

  @override
  Widget build(BuildContext context) {
    return ListLoadingState(
      itemCount: 5,
      itemBuilder: () => const MomentCardSkeleton(),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<dynamic> moments; // Will be List<MomentData> when properly typed

  const _ListView({required this.moments});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        AppLogger.userAction('Timeline pull to refresh');
        await context.read<MomentStore>().loadMoments();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // Space for FAB
        itemCount: moments.length,
        itemBuilder: (context, index) {
          final moment = moments[index];
          return _MomentListItem(moment: moment, index: index);
        },
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  final List<dynamic> moments;

  const _CalendarView({required this.moments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Calendar header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  AppLogger.userAction('Calendar previous month');
                },
              ),
              Text(
                'January 2024', // TODO: Make dynamic
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  AppLogger.userAction('Calendar next month');
                },
              ),
            ],
          ),
        ),
        // Calendar grid placeholder
        Expanded(
          child: GlassCard(
            margin: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Calendar View',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coming in Phase 5',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MomentListItem extends StatelessWidget {
  final dynamic moment; // Will be MomentData when properly typed
  final int index;

  const _MomentListItem({required this.moment, required this.index});

  @override
  Widget build(BuildContext context) {
    return MomentCard(
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
          // Moment header
          Row(
            children: [
              // Mood indicator
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green, // TODO: Map mood to color
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Today, 2:30 PM', // TODO: Format actual date
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Text', // TODO: Show actual content type
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Moment content preview
          Text(
            'Sample moment content that would be displayed here...', // TODO: Show actual content
            style: Theme.of(context).textTheme.bodyLarge,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Moment tags
          Wrap(
            spacing: 8,
            children: [
              _TagChip(label: 'personal'),
              _TagChip(label: 'reflection'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
