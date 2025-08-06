import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../stores/navigation_store.dart';
import '../../services/analytics_service.dart';
import '../../widgets/charts/mood_trend_chart.dart';
import '../../widgets/charts/writing_frequency_chart.dart';
import '../../widgets/charts/content_distribution_chart.dart';

part 'insight_header.dart';
part 'insight_stats.dart';
part 'insight_analysis.dart';

/// Premium insight screen for analytics and insights
class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Global keys to access child components for data refresh
  final GlobalKey<_PremiumStatsOverviewState> _statsKey = GlobalKey();
  final GlobalKey<_PremiumAnalyticsSectionState> _analyticsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Insight screen opened');
  }

  /// Refresh insight data when screen becomes visible
  void _refreshInsightData() {
    AppLogger.debug('Insight screen data refresh triggered');
    // Call refresh methods on child components without rebuilding them
    _statsKey.currentState?.refreshData();
    _analyticsKey.currentState?._refreshData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: VisibilityDetector(
        key: const Key('insight_screen'),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction > 0.5) {
            // Screen is visible, trigger data refresh for all components
            _refreshInsightData();
          }
        },
        child: PremiumScreenBackground(
          hasGeometricElements: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 120,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                // Simple header that scrolls with content
                _PremiumInsightHeader(),
                const SizedBox(height: 24),

                // Stats overview
                FadeInSlideUp(child: _PremiumStatsOverview(key: _statsKey)),

                const SizedBox(height: 24),

                // AI Analysis section
                FadeInSlideUp(
                  delay: const Duration(milliseconds: 200),
                  child: _PremiumAIAnalysisSection(),
                ),

                const SizedBox(height: 24),

                // Analytics section
                FadeInSlideUp(
                  delay: const Duration(milliseconds: 400),
                  child: _PremiumAnalyticsSection(key: _analyticsKey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
