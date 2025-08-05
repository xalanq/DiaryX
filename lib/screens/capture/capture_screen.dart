import 'package:diaryx/widgets/annotated_region/system_ui_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../routes.dart';
import '../../models/mood.dart';
import '../../models/draft.dart';
import '../../models/media_attachment.dart';
import '../../models/moment.dart';
import '../../services/camera_service.dart';
import '../../services/draft_service.dart';
import '../../stores/moment_store.dart';
import '../../utils/snackbar_helper.dart';

part 'capture_header.dart';
part 'capture_methods.dart';
part 'capture_actions.dart';

/// Premium capture screen for quick moment creation
class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key, this.isFromSplash = false});

  final bool isFromSplash;

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 80, // Fixed width for consistent alignment
          leading: Container(
            padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                // Check if we can pop back to previous screen (from home)
                // Otherwise navigate to home (from splash)
                if (AppRoutes.canPop(context)) {
                  AppRoutes.pop(context);
                } else {
                  AppRoutes.toHome(context);
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.black : Colors.white).withValues(
                    alpha: 0.1,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black).withValues(
                      alpha: 0.1,
                    ),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.isFromSplash
                      ? Icons.home_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        body: PremiumScreenBackground(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
              bottom: 40, // No bottom navigation space needed
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
