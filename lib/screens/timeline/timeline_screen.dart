import 'package:diaryx/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/error_states/error_states.dart';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/premium_button/premium_button.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../stores/moment_store.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';
import '../../models/moment.dart';
import '../../models/mood.dart';

part 'timeline_app_bar.dart';
part 'timeline_views.dart';
part 'timeline_items.dart';

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
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PremiumScreenBackground(
        child: Column(
          children: [
            // Premium App Bar with glass morphism
            _PremiumTimelineAppBar(
              isCalendarMode: _isCalendarMode,
              onViewModeChanged: () {
                setState(() {
                  _isCalendarMode = !_isCalendarMode;
                });
                AppLogger.userAction('Timeline view changed', {
                  'mode': _isCalendarMode ? 'calendar' : 'list',
                });
              },
              onFilterPressed: () {
                AppLogger.userAction('Timeline filter opened');
                // TODO: Implement filter bottom sheet
              },
            ),

            // Content with premium styling
            Expanded(
              child: Consumer<MomentStore>(
                builder: (context, momentStore, child) {
                  if (momentStore.isLoading && momentStore.moments.isEmpty) {
                    return const _PremiumTimelineLoadingState();
                  }

                  if (momentStore.error != null) {
                    return FadeInSlideUp(
                      child: ErrorState(
                        title: 'Failed to Load Moments',
                        message: momentStore.error,
                        onAction: () => momentStore.loadMoments(),
                      ),
                    );
                  }

                  if (momentStore.moments.isEmpty) {
                    return _PremiumNoMomentsState(
                      onCreateMoment: () {
                        AppRoutes.toCapture(context);
                      },
                    );
                  }

                  return _isCalendarMode
                      ? _PremiumCalendarView(moments: momentStore.moments)
                      : _PremiumListView(moments: momentStore.moments);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
