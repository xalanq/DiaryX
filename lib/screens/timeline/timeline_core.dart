part of 'timeline_screen.dart';

/// Sticky timeline sliver that renders timeline items with sticky date separators
class _StickyTimelineSliver extends StatelessWidget {
  final List<TimelineItem> timelineItems;
  final VoidCallback onCalendarTap;
  final Map<int, bool> expandedStates;
  final Function(int momentId, bool isExpanded) onExpandedChanged;
  final Map<int, bool> imagesExpandedStates;
  final Function(int momentId, bool isExpanded) onImagesExpandedChanged;

  const _StickyTimelineSliver({
    required this.timelineItems,
    required this.onCalendarTap,
    required this.expandedStates,
    required this.onExpandedChanged,
    required this.imagesExpandedStates,
    required this.onImagesExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[];

    // Group items by date for organization
    final dateGroups = <String, List<TimelineItem>>{};
    String? currentDateKey;

    for (final item in timelineItems) {
      if (item.type == TimelineItemType.dateSeparator) {
        currentDateKey = item.date != null
            ? '${item.date!.year}-${item.date!.month.toString().padLeft(2, '0')}-${item.date!.day.toString().padLeft(2, '0')}'
            : '';
        dateGroups[currentDateKey] = [item];
      } else if (currentDateKey != null) {
        dateGroups[currentDateKey]!.add(item);
      }
    }

    // Create slivers for each date group
    for (final entry in dateGroups.entries) {
      final items = entry.value;
      final dateSeparatorItem = items.first;
      final momentItems = items.skip(1).toList();

      // Add sticky header for date separator
      final groupSlivers = <Widget>[];
      groupSlivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyDateSeparatorDelegate(
            dateLabel: dateSeparatorItem.dateLabel!,
            momentCount: dateSeparatorItem.momentCount,
            onCalendarTap: onCalendarTap,
          ),
        ),
      );

      // Add moments for this date
      if (momentItems.isNotEmpty) {
        groupSlivers.add(
          SliverList.builder(
            itemCount: momentItems.length,
            itemBuilder: (context, index) {
              final item = momentItems[index];
              if (item.moment != null) {
                return _PremiumMomentListItem(
                  moment: item.moment!,
                  index: index,
                  isExpanded: expandedStates[item.moment!.id] ?? false,
                  onExpandedChanged: (isExpanded) {
                    onExpandedChanged(item.moment!.id, isExpanded);
                  },
                  isImagesExpanded:
                      imagesExpandedStates[item.moment!.id] ?? false,
                  onImagesExpandedChanged: (isExpanded) {
                    onImagesExpandedChanged(item.moment!.id, isExpanded);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      }

      slivers.add(SliverMainAxisGroup(slivers: groupSlivers));
    }

    return SliverMainAxisGroup(slivers: slivers);
  }
}
