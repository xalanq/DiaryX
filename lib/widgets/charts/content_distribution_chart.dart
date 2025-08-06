import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/analytics_service.dart';

/// Content distribution pie chart widget
class ContentDistributionChart extends StatelessWidget {
  final ContentDistribution distribution;
  final bool isDark;

  const ContentDistributionChart({
    super.key,
    required this.distribution,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (distribution.total == 0) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: _createSections(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    // Handle touch events if needed
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(flex: 1, child: _buildLegend(context)),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createSections() {
    final total = distribution.total.toDouble();
    final sections = <PieChartSectionData>[];

    if (distribution.textOnly > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.textOnly / total * 100,
          title: '${(distribution.textOnly / total * 100).round()}%',
          color: const Color(0xFF667EEA),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }

    if (distribution.withImages > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.withImages / total * 100,
          title: '${(distribution.withImages / total * 100).round()}%',
          color: const Color(0xFF11998E),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }

    if (distribution.withAudio > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.withAudio / total * 100,
          title: '${(distribution.withAudio / total * 100).round()}%',
          color: const Color(0xFFFF6B6B),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }

    if (distribution.withVideo > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.withVideo / total * 100,
          title: '${(distribution.withVideo / total * 100).round()}%',
          color: const Color(0xFF8B5CF6),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }

    if (distribution.multimedia > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.multimedia / total * 100,
          title: '${(distribution.multimedia / total * 100).round()}%',
          color: const Color(0xFFFFE66D),
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );
    }

    return sections;
  }

  Widget _buildLegend(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[];

    if (distribution.textOnly > 0) {
      items.add(
        _buildLegendItem(
          'Text Only',
          const Color(0xFF667EEA),
          distribution.textOnly,
          theme,
        ),
      );
    }

    if (distribution.withImages > 0) {
      items.add(
        _buildLegendItem(
          'With Images',
          const Color(0xFF11998E),
          distribution.withImages,
          theme,
        ),
      );
    }

    if (distribution.withAudio > 0) {
      items.add(
        _buildLegendItem(
          'With Audio',
          const Color(0xFFFF6B6B),
          distribution.withAudio,
          theme,
        ),
      );
    }

    if (distribution.withVideo > 0) {
      items.add(
        _buildLegendItem(
          'With Video',
          const Color(0xFF8B5CF6),
          distribution.withVideo,
          theme,
        ),
      );
    }

    if (distribution.multimedia > 0) {
      items.add(
        _buildLegendItem(
          'Multimedia',
          const Color(0xFFFFE66D),
          distribution.multimedia,
          theme,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _buildLegendItem(
    String label,
    Color color,
    int count,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                Text(
                  '$count',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.7,
                    ),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 48,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No content data available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
