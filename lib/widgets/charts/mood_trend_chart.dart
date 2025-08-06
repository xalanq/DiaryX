import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/analytics_service.dart';
import '../../themes/app_colors.dart';

/// Mood trend line chart widget
class MoodTrendChart extends StatelessWidget {
  final List<MoodTrendPoint> trendData;
  final bool isDark;

  const MoodTrendChart({
    super.key,
    required this.trendData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (trendData.isEmpty) {
      return _buildEmptyState(context);
    }

    final filteredData = trendData
        .where((point) => point.moodScore != null)
        .toList();

    if (filteredData.isEmpty) {
      return _buildNoMoodDataState(context);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  // Only show labels for specific values to reduce clutter
                  if (value == 1 || value == 3 || value == 5) {
                    return Text(
                      _getSimpleMoodLabel(value.toInt()),
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 35,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: trendData.length > 10
                    ? trendData.length / 4
                    : trendData.length / 3,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < trendData.length) {
                    final date = trendData[index].date;
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
          minX: 0,
          maxX: trendData.length.toDouble() - 1,
          minY: 1,
          maxY: 5,
          lineBarsData: [
            LineChartBarData(
              spots: _createSpots(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.3),
                    (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) =>
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  if (index >= 0 && index < trendData.length) {
                    final point = trendData[index];
                    final date = '${point.date.month}/${point.date.day}';
                    final moodLabel = _getMoodLabel(spot.y);
                    final momentCount = point.momentCount;

                    return LineTooltipItem(
                      '$date\n$moodLabel\n$momentCount moment${momentCount == 1 ? '' : 's'}',
                      TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    );
                  }
                  return null;
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createSpots() {
    final spots = <FlSpot>[];
    for (int i = 0; i < trendData.length; i++) {
      final point = trendData[i];
      if (point.moodScore != null) {
        spots.add(FlSpot(i.toDouble(), point.moodScore!));
      }
    }
    return spots;
  }

  String _getSimpleMoodLabel(int value) {
    // Simplified labels for Y axis
    switch (value) {
      case 5:
        return 'Great';
      case 3:
        return 'Okay';
      case 1:
        return 'Low';
      default:
        return '';
    }
  }

  String _getMoodLabel(double score) {
    // Detailed labels for tooltips
    if (score >= 4.8) return 'Happy/Excited';
    if (score >= 4.2) return 'Grateful';
    if (score >= 3.5) return 'Calm';
    if (score >= 2.8) return 'Thoughtful';
    if (score >= 2.3) return 'Bored';
    if (score >= 1.8) return 'Anxious';
    if (score >= 1.3) return 'Sad';
    if (score >= 1.0) return 'Angry';
    return 'Unknown';
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mood_outlined,
              size: 48,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No mood data available',
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

  Widget _buildNoMoodDataState(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mood_outlined,
              size: 48,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Start adding moments with moods\nto see your trends',
              textAlign: TextAlign.center,
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
