import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/draft.dart';
import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/camera_capture/camera_capture_widget.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../widgets/video_player/premium_video_player.dart';

import '../../../models/media_attachment.dart';

import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';
import '../../../services/draft_service.dart';
import '../../../services/camera_service.dart';
import '../../../utils/snackbar_helper.dart';
import '../../../routes.dart';

/// Premium camera moment creation screen
class CameraMomentScreen extends StatefulWidget {
  final bool isFromTextMoment;
  final bool isEditingMode;

  const CameraMomentScreen({
    super.key,
    this.isFromTextMoment = false,
    this.isEditingMode = false,
  });

  @override
  State<CameraMomentScreen> createState() => _CameraMomentScreenState();
}

class _CameraMomentScreenState extends State<CameraMomentScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();
  final DraftService _draftService = DraftService();

  String? _capturedMediaPath;
  MediaType? _mediaType;
  Duration? _videoDuration;
  String? _videoThumbnailPath;
  String _currentPhase = 'capture'; // capture, preview

  // Instruction hint visibility
  bool _showInstructions = true;
  Timer? _instructionTimer;

  @override
  void initState() {
    super.initState();
    _startInstructionTimer();
    AppLogger.userAction('Camera moment screen opened');
  }

  void _startInstructionTimer() {
    _instructionTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showInstructions = false;
        });
      }
    });
  }

  void _onPhotoTaken(String filePath) {
    setState(() {
      _capturedMediaPath = filePath;
      _mediaType = MediaType.image;
      _currentPhase = 'preview';
    });

    HapticFeedback.mediumImpact();
    AppLogger.userAction('Photo captured for moment');
  }

  void _onVideoRecorded(String filePath, Duration duration) async {
    setState(() {
      _capturedMediaPath = filePath;
      _mediaType = MediaType.video;
      _videoDuration = duration;
      _currentPhase = 'preview';
    });

    HapticFeedback.mediumImpact();
    AppLogger.userAction('Video recorded for moment', {
      'filePath': filePath,
      'duration': duration.toString(),
      'durationSeconds': duration.inSeconds,
    });

    // Generate video thumbnail in the background
    _generateVideoThumbnail(filePath);
  }

  /// Generate video thumbnail in the background
  Future<void> _generateVideoThumbnail(String videoPath) async {
    try {
      final CameraService cameraService = CameraService.instance;
      final String? thumbnailPath = await cameraService.generateVideoThumbnail(
        videoPath,
      );

      if (thumbnailPath != null && mounted) {
        setState(() {
          _videoThumbnailPath = thumbnailPath;
        });
        AppLogger.info('Video thumbnail generated and set: $thumbnailPath');
      }
    } catch (e) {
      AppLogger.error('Failed to generate video thumbnail', e);
    }
  }

  void _retakeMedia() {
    setState(() {
      _capturedMediaPath = null;
      _mediaType = null;
      _videoDuration = null;
      _videoThumbnailPath = null;
      _currentPhase = 'capture';
    });

    _textController.clear();
    HapticFeedback.selectionClick();
    AppLogger.userAction('Media retake requested');
  }

  Future<void> _addToDraftAndNavigate() async {
    if (_capturedMediaPath == null || _mediaType == null) return;

    try {
      // Create draft media data
      final capturedMedia = DraftMediaData(
        filePath: _capturedMediaPath!,
        mediaType: _mediaType!,
        duration: _videoDuration?.inSeconds.toDouble(),
        thumbnailPath: _mediaType == MediaType.video
            ? _videoThumbnailPath
            : null,
      );

      // Add media to appropriate storage based on editing mode
      if (widget.isEditingMode) {
        // Editing mode: add to temporary editing state
        _draftService.addMediaToEditingTemp(capturedMedia);

        // Add text content to editing temp if any
        final textContent = _textController.text.trim();
        if (textContent.isNotEmpty) {
          final currentTemp = _draftService.loadEditingTemp();
          _draftService.saveEditingTemp(
            content: textContent,
            moods: currentTemp?.moods,
            mediaAttachments: currentTemp?.mediaAttachments,
          );
        }

        AppLogger.userAction('Camera media added to editing temp', {
          'media_path': _capturedMediaPath,
          'media_type': _mediaType!.name,
          'has_text': textContent.isNotEmpty,
        });
      } else {
        // New moment mode: add to draft
        await _draftService.addMediaToDraft(capturedMedia);

        // Add text content to draft if any
        final textContent = _textController.text.trim();
        if (textContent.isNotEmpty) {
          final currentDraft = await _draftService.loadDraft();
          await _draftService.saveDraft(
            content: textContent,
            moods: currentDraft?.moods,
            mediaAttachments: currentDraft?.mediaAttachments,
          );
        }

        AppLogger.userAction('Camera media added to draft', {
          'media_path': _capturedMediaPath,
          'media_type': _mediaType!.name,
          'has_text': textContent.isNotEmpty,
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
      AppLogger.error('Failed to add camera media to draft', e);

      if (mounted) {
        SnackBarHelper.showError(context, 'Failed to add media to draft: $e');
      }
    }
  }

  void _goBack() {
    if (_currentPhase == 'preview') {
      _retakeMedia();
    } else {
      AppRoutes.pop(context);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    _instructionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SystemUiWrapper(
      forceDark: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentPhase(isDark),
        ),
      ),
    );
  }

  Widget _buildCurrentPhase(bool isDark) {
    switch (_currentPhase) {
      case 'capture':
        return _buildCapturePhase(isDark);
      case 'preview':
        return _buildPreviewPhase();
      default:
        return _buildCapturePhase(isDark);
    }
  }

  Widget _buildCapturePhase(bool isDark) {
    return Stack(
      children: [
        // Camera widget
        CameraCaptureWidget(
          onPhotoTaken: _onPhotoTaken,
          onVideoRecorded: _onVideoRecorded,
        ),

        // Back button
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: _goBack,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.darkTextPrimary,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Instructions - positioned above the camera controls (auto-hide after 2s)
        Positioned(
          bottom:
              140 +
              MediaQuery.of(
                context,
              ).padding.bottom, // Position above camera controls + safe area
          left: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: _showInstructions ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: const Text(
                'Tap to take photo • Long press to record video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewPhase() {
    return Stack(
      children: [
        // Media preview
        if (_capturedMediaPath != null) _buildMediaPreview(),

        // Controls overlay
        Column(
          children: [
            // Top controls
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _goBack,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.darkTextPrimary,
                          size: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _mediaType == MediaType.image
                          ? 'Photo Preview'
                          : 'Video Preview',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bottom controls
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: PremiumButton(
                        text: 'Retake',
                        onPressed: _retakeMedia,
                        isOutlined: true,
                        backgroundColor: const Color.fromARGB(10, 0, 0, 0),
                        icon: Icons.refresh,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PremiumButton(
                        text: 'Next',
                        onPressed: _addToDraftAndNavigate,
                        icon: Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    if (_capturedMediaPath == null) return const SizedBox.shrink();

    final file = File(_capturedMediaPath!);
    AppLogger.info(
      'Building media preview for: $_capturedMediaPath, mediaType: ${_mediaType?.name}',
    );

    if (_mediaType == MediaType.image) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
        ),
      );
    } else {
      // For video, use the premium video player with modern controls
      AppLogger.info(
        'Creating PremiumVideoPlayer with path: $_capturedMediaPath',
      );
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PremiumVideoPlayer(
          videoPath: _capturedMediaPath!,
          autoPlay: false,
          looping: false,
          showControls: true,
          allowFullscreen: false,
          bottomShift: 64,
          topShift: 10,
          heroTag: 'camera_preview_video',
          onPlaybackComplete: () {
            AppLogger.userAction('Video preview playback completed');
          },
          onPositionChanged: (position) {
            // Optional: Track video position for analytics
            AppLogger.debug('Video position: ${position.toString()}');
          },
        ),
      );
    }
  }
}
