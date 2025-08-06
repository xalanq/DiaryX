import 'package:flutter/material.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../routes.dart';

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

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Insight screen opened');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
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
              FadeInSlideUp(child: _PremiumStatsOverview()),

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
                child: _PremiumAnalyticsSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
