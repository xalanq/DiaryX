import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/analytics_service.dart';
import '../../themes/app_colors.dart';

/// Writing frequency bar chart widget
class WritingFrequencyChart extends StatelessWidget {
  final List<WritingFrequencyPoint> frequencyData;
  final bool isDark;

  const WritingFrequencyChart({
    super.key,
    required this.frequencyData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (frequencyData.isEmpty) {
      return _buildEmptyState(context);
    }

    final filteredData = frequencyData
        .where((point) => point.momentCount > 0)
        .toList();

    if (filteredData.isEmpty) {
      return _buildEmptyState(context);
    }

    final maxY = _getMaxY(filteredData);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
                reservedSize: 25,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < filteredData.length) {
                    final date = filteredData[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${date.month}/${date.day}',
                        style: TextStyle(
                          color: (isDark ? Colors.white : Colors.black)
                              .withValues(alpha: 0.6),
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 25,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _createBarGroups(filteredData),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              // Modern glass morphism tooltip design
              getTooltipColor: (group) => isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.9)
                  : AppColors.lightSurface.withValues(alpha: 0.95),
              tooltipBorder: BorderSide(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
                width: 1,
              ),
              tooltipRoundedRadius: 12,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final index = group.x.toInt();
                if (index >= 0 && index < filteredData.length) {
                  final point = filteredData[index];
                  final date = '${point.date.month}/${point.date.day}';
                  final count = point.momentCount;

                  return BarTooltipItem(
                    '$date\n$count moment${count == 1 ? '' : 's'}',
                    TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  double _getMaxY(List<WritingFrequencyPoint> filteredData) {
    if (filteredData.isEmpty) return 5;
    final maxCount = filteredData
        .map((e) => e.momentCount)
        .reduce((a, b) => a > b ? a : b);
    return (maxCount + 1).toDouble();
  }

  List<BarChartGroupData> _createBarGroups(
    List<WritingFrequencyPoint> filteredData,
  ) {
    return filteredData.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: point.momentCount.toDouble(),
            color: _getBarColor(point.momentCount),
            width: 10, // Slightly wider for better visual impact
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: _getEnhancedBarGradient(point.momentCount),
              stops: const [0.0, 0.6, 1.0], // Enhanced gradient stops
            ),
            // Add subtle shadow effect
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(filteredData),
              color: (isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.04,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Color _getBarColor(int count) {
    if (count == 0) {
      return (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1);
    } else if (count <= 2) {
      return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    } else {
      return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    }
  }

  /// Enhanced gradient with better visual depth
  List<Color> _getEnhancedBarGradient(int count) {
    if (count == 0) {
      final baseColor = (isDark ? Colors.white : Colors.black).withValues(
        alpha: 0.1,
      );
      return [
        baseColor.withValues(alpha: 0.05),
        baseColor.withValues(alpha: 0.08),
        baseColor,
      ];
    }

    Color primaryColor;
    Color secondaryColor;

    if (count <= 2) {
      // Low activity - subtle gradient
      primaryColor = isDark
          ? AppColors.darkSecondary
          : AppColors.lightSecondary;
      secondaryColor = primaryColor.withValues(alpha: 0.7);
    } else {
      // High activity - vibrant gradient
      primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      secondaryColor = primaryColor.withValues(alpha: 0.8);
    }

    return [
      secondaryColor.withValues(alpha: 0.4),
      secondaryColor,
      primaryColor,
    ];
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: (isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 32,
                color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No writing data available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.6,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Start writing to see your patterns',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
