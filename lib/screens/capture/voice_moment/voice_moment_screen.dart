import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/draft.dart';
import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/audio_recorder/audio_recorder.dart';
import '../../../widgets/audio_recorder/audio_player.dart';

import '../../../widgets/premium_button/premium_button.dart';

import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';
import '../../../routes.dart';

import '../../../models/media_attachment.dart';
import '../../../services/draft_service.dart';

/// Premium voice moment creation screen
class VoiceMomentScreen extends StatefulWidget {
  final bool isFromTextMoment;
  final bool isEditingMode;

  const VoiceMomentScreen({
    super.key,
    this.isFromTextMoment = false,
    this.isEditingMode = false,
  });

  @override
  State<VoiceMomentScreen> createState() => _VoiceMomentScreenState();
}

class _VoiceMomentScreenState extends State<VoiceMomentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  final DraftService _draftService = DraftService();
  final PremiumAudioRecorderKey _audioRecorderKey =
      GlobalKey<PremiumAudioRecorderState>();

  String? _recordedAudioPath;
  Duration? _recordingDuration;
  bool _isSaving = false;
  String _currentPhase = 'record'; // record, review, save

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    AppLogger.userAction('Voice moment screen opened');
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    // Stop any ongoing recording when exiting the page
    _audioRecorderKey.currentState?.resetState();
    super.dispose();
  }

  void _onRecordingStart() {
    setState(() {
      _currentPhase = 'recording';
    });

    HapticFeedback.mediumImpact();
    AppLogger.userAction('Voice recording started');
  }

  void _onRecordingComplete(String filePath, Duration duration) {
    HapticFeedback.heavyImpact();
    AppLogger.userAction('Voice recording completed', {
      'file_path': filePath,
      'duration_seconds': duration.inSeconds,
    });

    // First set to transitioning state for fade out
    setState(() {
      _currentPhase = 'transitioning';
    });

    // After fade out animation completes, set data and switch to review
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _recordedAudioPath = filePath;
          _recordingDuration = duration;
          _currentPhase = 'review';
        });
      }
    });
  }

  void _retakeRecording() {
    HapticFeedback.lightImpact();
    AppLogger.userAction('Voice recording retake requested');

    // First set to transitioning state for fade out
    setState(() {
      _currentPhase = 'transitioning';
    });

    // After fade out animation completes, reset data and switch to record
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        setState(() {
          _recordedAudioPath = null;
          _recordingDuration = null;
          _currentPhase = 'record';
        });

        // Reset audio recorder state
        _audioRecorderKey.currentState?.resetState();
      }
    });
  }

  Future<void> _addToDraftAndNavigate() async {
    if (_recordedAudioPath == null) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      // Create draft media data
      final audioMedia = DraftMediaData(
        filePath: _recordedAudioPath!,
        mediaType: MediaType.audio,
        duration: _recordingDuration?.inSeconds.toDouble(),
      );

      // Add audio to appropriate storage based on editing mode
      if (widget.isEditingMode) {
        // Editing mode: add to temporary editing state
        _draftService.addMediaToEditingTemp(audioMedia);

        AppLogger.userAction('Voice recording added to editing temp', {
          'audio_path': _recordedAudioPath,
          'duration_seconds': _recordingDuration?.inSeconds,
        });
      } else {
        // New moment mode: add to draft
        await _draftService.addMediaToDraft(audioMedia);

        AppLogger.userAction('Voice recording added to draft', {
          'audio_path': _recordedAudioPath,
          'duration_seconds': _recordingDuration?.inSeconds,
        });
      }

      // Navigate back to text moment screen or create new one
      if (mounted) {
        if (widget.isFromTextMoment) {
          // Return to existing text moment screen
          AppRoutes.pop(context, true);
        } else {
          // Create new text moment screen (original behavior)
          AppRoutes.toTextMomentAndReplace(context);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to add voice recording to draft', e);
      _showErrorSnackBar('Failed to add recording to draft');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red.shade400),
      );
    }
  }

  Widget _buildMainContent() {
    return Stack(
      children: [
        // Recording phase content with fade out animation
        AnimatedOpacity(
          opacity: (_currentPhase == 'record' || _currentPhase == 'recording')
              ? 1.0
              : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Phase indicator with smooth transition
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildPhaseIndicator(),
                ),
                const SizedBox(height: 48),

                // Recording section with unified layout
                _buildUnifiedRecordingSection(),
              ],
            ),
          ),
        ),

        // Review phase content with fade in animation
        AnimatedOpacity(
          opacity: _currentPhase == 'review' ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Phase indicator
                _buildPhaseIndicator(),
                const SizedBox(height: 48),

                // Review section
                _buildReviewSection(),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80, // Fixed width for consistent alignment
      leading: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => AppRoutes.pop(context),
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
              Icons.arrow_back_ios_new_rounded,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              size: 18,
            ),
          ),
        ),
      ),
      title: Text(
        'Voice Moment',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      actions: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(isDark),
        body: PremiumScreenBackground(
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(child: _buildMainContent()),

                    // Bottom action buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String phaseText;
    IconData phaseIcon;
    Color phaseColor;

    switch (_currentPhase) {
      case 'record':
        phaseText = 'Ready to Record';
        phaseIcon = Icons.mic_rounded;
        phaseColor = Colors.blue;
        break;
      case 'recording':
        phaseText = 'Recording...';
        phaseIcon = Icons.radio_button_checked_rounded;
        phaseColor = Colors.red;
        break;
      case 'transitioning':
        // During transition, maintain previous appearance based on audio path
        if (_recordedAudioPath != null) {
          // Transitioning from review back to record
          phaseText = 'Preview';
          phaseIcon = Icons.play_arrow_rounded;
          phaseColor = Colors.green;
        } else {
          // Transitioning from record to review
          phaseText = 'Recording...';
          phaseIcon = Icons.radio_button_checked_rounded;
          phaseColor = Colors.red;
        }
        break;
      case 'review':
        phaseText = 'Preview';
        phaseIcon = Icons.play_arrow_rounded;
        phaseColor = Colors.green;
        break;
      default:
        phaseText = 'Voice Moment';
        phaseIcon = Icons.mic_rounded;
        phaseColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    }

    return Row(
      key: ValueKey(_currentPhase),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(phaseIcon, color: phaseColor, size: 24),
        const SizedBox(width: 12),
        Text(
          phaseText,
          style: theme.textTheme.titleMedium?.copyWith(
            color: phaseColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildUnifiedRecordingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Audio recorder component (handles button animation internally)
        FadeInSlideUp(
          delay: const Duration(milliseconds: 200),
          child: PremiumAudioRecorder(
            key: _audioRecorderKey,
            onRecordingStart: _onRecordingStart,
            onRecordingComplete: _onRecordingComplete,
            maxDuration: null, // Remove duration limit
            showWaveform: true,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Audio playback
        PremiumAudioPlayer(
          audioPath: _recordedAudioPath ?? '',
          showDuration: true,
        ),

        const SizedBox(height: 24),

        // Simple status message
        Text(
          'Your voice recording is ready! Tap "Next" to add it to your moment.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    // Only show buttons in review phase
    return AnimatedOpacity(
      opacity: _currentPhase == 'review' ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: PremiumButton(
                text: 'Retake',
                onPressed: _currentPhase == 'review' ? _retakeRecording : null,
                isOutlined: true,
                icon: Icons.refresh,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PremiumButton(
                text: 'Next',
                onPressed:
                    (_currentPhase == 'review' &&
                        _recordedAudioPath != null &&
                        !_isSaving)
                    ? _addToDraftAndNavigate
                    : null,
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
