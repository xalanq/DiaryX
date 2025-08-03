import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/animations/premium_animations.dart';
import '../../../widgets/audio_recorder/audio_recorder.dart';
import '../../../widgets/audio_recorder/audio_player.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../stores/moment_store.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';
import '../../../databases/app_database.dart';
import '../../../models/media_attachment.dart';

/// 音频转录的最大时长阈值（超过此时长不进行转录）
const Duration kMaxTranscriptionDuration = Duration(minutes: 3);

/// Premium voice moment creation screen
class VoiceMomentScreen extends StatefulWidget {
  const VoiceMomentScreen({super.key});

  @override
  State<VoiceMomentScreen> createState() => _VoiceMomentScreenState();
}

class _VoiceMomentScreenState extends State<VoiceMomentScreen>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  String? _recordedAudioPath;
  Duration? _recordingDuration;
  bool _isTranscribing = false;
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
    _textController.dispose();
    _textFocus.dispose();
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
    setState(() {
      _recordedAudioPath = filePath;
      _recordingDuration = duration;
      _currentPhase = 'review';
    });

    HapticFeedback.heavyImpact();
    AppLogger.userAction('Voice recording completed', {
      'file_path': filePath,
      'duration_seconds': duration.inSeconds,
    });

    // TODO: Start transcription process here
    _startTranscription();
  }

  void _startTranscription() async {
    if (_recordedAudioPath == null || _recordingDuration == null) return;

    // 检查录音时长是否超过转录阈值
    if (_recordingDuration! > kMaxTranscriptionDuration) {
      AppLogger.info(
        'Recording duration (${_recordingDuration!.inMinutes}:${(_recordingDuration!.inSeconds % 60).toString().padLeft(2, '0')}) exceeds transcription limit (${kMaxTranscriptionDuration.inMinutes}:00), skipping transcription',
      );
      _textController.text =
          'Recording is too long for automatic transcription. You can add notes manually below.';
      return;
    }

    setState(() => _isTranscribing = true);

    try {
      // TODO: Implement actual transcription using AI service
      // For now, just simulate the process
      await Future.delayed(const Duration(seconds: 2));

      // Placeholder transcription
      _textController.text =
          'Voice transcription will be available once AI services are integrated.';

      AppLogger.info('Voice transcription completed (placeholder)');
    } catch (e) {
      AppLogger.error('Voice transcription failed', e);
      _showErrorSnackBar('Failed to transcribe audio');
    } finally {
      if (mounted) {
        setState(() => _isTranscribing = false);
      }
    }
  }

  void _retakeRecording() {
    setState(() {
      _recordedAudioPath = null;
      _recordingDuration = null;
      _currentPhase = 'record';
      _textController.clear();
    });

    HapticFeedback.lightImpact();
    AppLogger.userAction('Voice recording retake requested');
  }

  void _saveMoment() async {
    if (_recordedAudioPath == null) return;

    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      // Create the moment with optional text content
      final textContent = _textController.text.trim();

      final moment = MomentData(
        id: 0, // Will be auto-generated
        content: textContent.isNotEmpty ? textContent : 'Voice recording',
        moods: null, // Will be analyzed later
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        aiProcessed: false,
      );

      // Create media attachment for the audio file
      final mediaAttachment = MediaAttachmentData(
        id: 0, // Will be auto-generated
        momentId: 0, // Will be updated after moment creation
        filePath: _recordedAudioPath!,
        mediaType: MediaType.audio,
        fileSize: null, // TODO: Calculate file size
        duration: _recordingDuration?.inSeconds.toDouble(),
        thumbnailPath: null,
        createdAt: DateTime.now(),
      );

      // Save the moment with media attachment
      await momentStore.createMomentWithMedia(moment, [mediaAttachment]);

      AppLogger.userAction('Voice moment saved successfully', {
        'audio_path': _recordedAudioPath,
        'duration_seconds': _recordingDuration?.inSeconds,
        'has_text': textContent.isNotEmpty,
      });

      // Navigate back with success feedback
      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessSnackBar('Voice moment saved successfully!');
      }
    } catch (e) {
      AppLogger.error('Failed to save voice moment', e);
      _showErrorSnackBar('Failed to save moment');
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green.shade400),
    );
  }

  Widget _buildMainContent() {
    // For recording phase, use Center for vertical centering
    if (_currentPhase == 'record' || _currentPhase == 'recording') {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Phase indicator
            FadeInSlideUp(child: _buildPhaseIndicator()),
            const SizedBox(height: 48),

            // Recording section
            _buildRecordingSection(),

            const SizedBox(height: 96),
          ],
        ),
      );
    }

    // For review phase, use SingleChildScrollView for scrolling
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // 键盘高度 + 额外间距
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          // Phase indicator
          FadeInSlideUp(child: _buildPhaseIndicator()),
          const SizedBox(height: 48),

          // Review section
          if (_currentPhase == 'review') _buildReviewSection(),
          const SizedBox(height: 40),
        ],
      ),
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
          onTap: () => Navigator.of(context).pop(),
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
        'New Moment',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
      actions: [
        // Save button - only show in review phase
        if (_currentPhase == 'review')
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: _isSaving
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  )
                : PremiumButton(
                    text: 'Save',
                    onPressed: _recordedAudioPath != null ? _saveMoment : null,
                    borderRadius: 18,
                    constraints: const BoxConstraints(maxWidth: 100),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    textMaxLines: 1,
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // Ensure text color is white
                    ),
                    animationDuration: const Duration(milliseconds: 200),
                  ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      child: GestureDetector(
        onTap: () {
          // Tap empty area to dismiss keyboard
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset:
              false, // Prevent background from moving when keyboard appears
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
      case 'review':
        phaseText = 'Review & Edit';
        phaseIcon = Icons.edit_rounded;
        phaseColor = Colors.green;
        break;
      default:
        phaseText = 'New Moment';
        phaseIcon = Icons.mic_rounded;
        phaseColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    }

    return Row(
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

  Widget _buildRecordingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInSlideUp(
          delay: const Duration(milliseconds: 200),
          child: PremiumAudioRecorder(
            onRecordingStart: _onRecordingStart,
            onRecordingComplete: _onRecordingComplete,
            maxDuration: null, // 移除时长限制
            showWaveform: true,
          ),
        ),
        const SizedBox(height: 32),

        FadeInSlideUp(
          delay: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Recording has no time limit, but transcription is only available for recordings under ${kMaxTranscriptionDuration.inMinutes} minutes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Audio playback
        if (_recordedAudioPath != null) ...[
          FadeInSlideUp(
            child: PremiumAudioPlayer(
              audioPath: _recordedAudioPath!,
              showDuration: true,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Transcription section
        FadeInSlideUp(
          delay: const Duration(milliseconds: 200),
          child: PremiumGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.text_fields_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Transcription & Notes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (_isTranscribing) ...[
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _textController,
                  focusNode: _textFocus,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: _isTranscribing
                        ? 'Transcribing audio...'
                        : 'Add notes or edit transcription...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).cardColor.withValues(alpha: 0.3),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  enabled: !_isTranscribing,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_currentPhase == 'record' || _currentPhase == 'recording') {
      return const SizedBox.shrink();
    }

    // Only show retake button since save is now in AppBar
    return FadeInSlideUp(
      delay: const Duration(milliseconds: 400),
      child: AppButton(
        text: 'Retake Recording',
        onPressed: _retakeRecording,
        type: AppButtonType.ghost,
        icon: Icons.refresh_rounded,
      ),
    );
  }
}
