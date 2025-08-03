import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

part 'capture_header.dart';
part 'capture_methods.dart';
part 'capture_actions.dart';

/// Premium capture screen for quick moment creation
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    AppLogger.userAction('Capture screen opened');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            bottom: 120, // Space for bottom navigation
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Premium welcome header
              FadeInSlideUp(child: _PremiumWelcomeHeader()),
              const SizedBox(height: 32),

              // Hero action buttons with staggered animation
              StaggeredAnimationContainer(
                staggerDelay: const Duration(milliseconds: 150),
                children: [
                  _PremiumCaptureSection(),
                  const SizedBox(height: 24),
                  _PremiumQuickActions(),
                  const SizedBox(height: 24),
                  _PremiumRecentMoments(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
