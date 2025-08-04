import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../widgets/annotated_region/system_ui_wrapper.dart';
import '../../../widgets/camera_capture/camera_capture_widget.dart';
import '../../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../../widgets/premium_button/premium_button.dart';
import '../../../widgets/gradient_background/gradient_background.dart';
import '../../../stores/moment_store.dart';
import '../../../models/media_attachment.dart';
import '../../../databases/app_database.dart';
import '../../../themes/app_colors.dart';
import '../../../utils/app_logger.dart';

/// Premium camera moment creation screen
class CameraMomentScreen extends StatefulWidget {
  const CameraMomentScreen({super.key});

  @override
  State<CameraMomentScreen> createState() => _CameraMomentScreenState();
}

class _CameraMomentScreenState extends State<CameraMomentScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocus = FocusNode();

  String? _capturedMediaPath;
  MediaType? _mediaType;
  Duration? _videoDuration;
  bool _isSaving = false;
  String _currentPhase = 'capture'; // capture, preview, save

  // Instruction hint visibility
  bool _showInstructions = true;
  Timer? _instructionTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInstructionTimer();
    AppLogger.userAction('Camera moment screen opened');
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
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

  void _onVideoRecorded(String filePath, Duration duration) {
    setState(() {
      _capturedMediaPath = filePath;
      _mediaType = MediaType.video;
      _videoDuration = duration;
      _currentPhase = 'preview';
    });

    HapticFeedback.mediumImpact();
    AppLogger.userAction('Video recorded for moment');
  }

  void _retakeMedia() {
    setState(() {
      _capturedMediaPath = null;
      _mediaType = null;
      _videoDuration = null;
      _currentPhase = 'capture';
    });

    _textController.clear();
    HapticFeedback.selectionClick();
    AppLogger.userAction('Media retake requested');
  }

  void _proceedToSave() {
    setState(() {
      _currentPhase = 'save';
    });

    // Auto-focus text field
    Future.delayed(const Duration(milliseconds: 300), () {
      _textFocus.requestFocus();
    });

    AppLogger.userAction('Proceeding to save camera moment');
  }

  Future<void> _saveMoment() async {
    if (_capturedMediaPath == null || _mediaType == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final momentStore = Provider.of<MomentStore>(context, listen: false);

      // Create the moment data
      final textContent = _textController.text.trim();

      final moment = MomentData(
        id: 0, // Will be auto-generated
        content: textContent.isNotEmpty
            ? textContent
            : (_mediaType == MediaType.image ? 'Photo moment' : 'Video moment'),
        moods: null, // Will be analyzed later
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        aiProcessed: false,
      );

      // Create media attachment for the captured media
      final mediaAttachment = MediaAttachmentData(
        id: 0, // Will be auto-generated
        momentId: 0, // Will be updated after moment creation
        filePath: _capturedMediaPath!,
        mediaType: _mediaType!,
        fileSize: null, // TODO: Calculate file size
        duration: _videoDuration?.inSeconds.toDouble(),
        thumbnailPath: null,
        createdAt: DateTime.now(),
      );

      // Save the moment with media attachment
      await momentStore.createMomentWithMedia(moment, [mediaAttachment]);

      // Success feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _mediaType == MediaType.image
                      ? 'Photo moment saved!'
                      : 'Video moment saved!',
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back after short delay
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }

      AppLogger.userAction('Camera moment saved successfully');
    } catch (e) {
      AppLogger.error('Failed to save camera moment', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save moment: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _goBack() {
    if (_currentPhase == 'save') {
      setState(() {
        _currentPhase = 'preview';
      });
    } else if (_currentPhase == 'preview') {
      _retakeMedia();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _textController.dispose();
    _textFocus.dispose();
    _instructionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SystemUiWrapper(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentPhase(),
        ),
      ),
    );
  }

  Widget _buildCurrentPhase() {
    switch (_currentPhase) {
      case 'capture':
        return _buildCapturePhase();
      case 'preview':
        return _buildPreviewPhase();
      case 'save':
        return _buildSavePhase();
      default:
        return _buildCapturePhase();
    }
  }

  Widget _buildCapturePhase() {
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
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topLeft,
              child: PremiumGlassCard(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: _goBack,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
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
          left: 16,
          right: 16,
          child: AnimatedOpacity(
            opacity: _showInstructions ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: PremiumGlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    PremiumGlassCard(
                      padding: const EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: _goBack,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: PremiumButton(
                        text: 'Retake',
                        onPressed: _retakeMedia,
                        isOutlined: true,
                        icon: Icons.refresh,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PremiumButton(
                        text: 'Continue',
                        onPressed: _proceedToSave,
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

  Widget _buildSavePhase() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: _buildSaveAppBar(isDark),
        body: PremiumScreenBackground(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 24,
              bottom: 40,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media preview section
                if (_capturedMediaPath != null) ...[
                  _buildMediaPreviewCard(isDark),
                  const SizedBox(height: 24),
                ],

                // Text input section
                _buildTextInputSection(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSaveAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80,
      leading: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: _goBack,
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
                  onPressed: _saveMoment,
                  borderRadius: 18,
                  constraints: const BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  textMaxLines: 1,
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                ),
        ),
      ],
    );
  }

  Widget _buildMediaPreviewCard(bool isDark) {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                _mediaType == MediaType.image
                    ? Icons.photo_camera
                    : Icons.videocam,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _mediaType == MediaType.image ? 'Photo' : 'Video',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Media thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: _buildMediaThumbnailContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(
              Icons.edit_note,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Text input card
        PremiumGlassCard(
          child: TextField(
            controller: _textController,
            focusNode: _textFocus,
            maxLines: null,
            minLines: 6,
            decoration: InputDecoration(
              hintText: _mediaType == MediaType.image
                  ? 'Describe your photo moment...'
                  : 'Describe your video moment...',
              hintStyle: TextStyle(
                color:
                    (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)
                        .withValues(alpha: 0.6),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaThumbnailContent() {
    if (_capturedMediaPath == null) return const SizedBox.shrink();

    final file = File(_capturedMediaPath!);

    if (_mediaType == MediaType.image) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.error, size: 40, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      // Video preview with play icon and duration
      return Container(
        color: Colors.black87,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.play_circle_filled, color: Colors.white, size: 60),
            if (_videoDuration != null)
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_videoDuration!.inMinutes}:${(_videoDuration!.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  Widget _buildMediaPreview() {
    if (_capturedMediaPath == null) return const SizedBox.shrink();

    final file = File(_capturedMediaPath!);

    if (_mediaType == MediaType.image) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
        ),
      );
    } else {
      // For video, show a placeholder with play button
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_filled, color: Colors.white, size: 80),
        ),
      );
    }
  }
}
