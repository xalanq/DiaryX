import 'package:flutter/material.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../routes.dart';

part 'report_header.dart';
part 'report_stats.dart';
part 'report_analysis.dart';

/// Premium report screen for analytics and insights
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Report screen opened');
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
              _PremiumReportHeader(),
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
