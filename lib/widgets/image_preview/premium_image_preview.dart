import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/video_player/premium_video_player.dart';
import '../../utils/app_logger.dart';

/// Premium media preview screen with advanced glass morphism design
/// Supports single image/video and gallery mode with modern UI/UX elements
class PremiumImagePreview extends StatefulWidget {
  final List<String> mediaPaths; // Can contain both images and videos
  final int initialIndex;
  final String? heroTag;
  final bool enableHeroAnimation;

  const PremiumImagePreview({
    super.key,
    required this.mediaPaths,
    this.initialIndex = 0,
    this.heroTag,
    this.enableHeroAnimation = true,
  });

  /// Show single media (image or video) preview with hero animation
  static Future<void> showSingle(
    BuildContext context,
    String mediaPath, {
    String? heroTag,
    bool enableHeroAnimation = true,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PremiumImagePreview(
              mediaPaths: [mediaPath],
              initialIndex: 0,
              heroTag: heroTag,
              enableHeroAnimation: enableHeroAnimation,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        barrierDismissible: true,
        opaque: false,
      ),
    );
  }

  /// Show gallery mode with multiple media files (images and videos)
  static Future<void> showGallery(
    BuildContext context,
    List<String> mediaPaths, {
    int initialIndex = 0,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PremiumImagePreview(
              mediaPaths: mediaPaths,
              initialIndex: initialIndex,
              heroTag: heroTag,
              enableHeroAnimation: true,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        barrierDismissible: true,
        opaque: false,
      ),
    );
  }

  @override
  State<PremiumImagePreview> createState() => _PremiumImagePreviewState();
}

class _PremiumImagePreviewState extends State<PremiumImagePreview>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _overlayController;
  late Animation<double> _overlayAnimation;

  int _currentIndex = 0;
  bool _isOverlayVisible = true;
  bool _isZoomed = false;

  /// Helper method to determine if a file is a video based on extension
  bool _isVideoFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    return [
      'mp4',
      'mov',
      'avi',
      'mkv',
      'webm',
      '3gp',
      'flv',
      'm4v',
    ].contains(extension);
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Initialize overlay animation controller for fade effects
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeInOut),
    );

    // Start overlay animation
    _overlayController.forward();

    AppLogger.userAction('Media preview opened', {
      'mediaCount': widget.mediaPaths.length,
      'initialIndex': widget.initialIndex,
      'mediaTypes': widget.mediaPaths
          .map((path) => _isVideoFile(path) ? 'video' : 'image')
          .toList(),
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _overlayController.dispose();
    super.dispose();
  }

  /// Toggle overlay visibility with smooth animation
  void _toggleOverlay() {
    setState(() {
      _isOverlayVisible = !_isOverlayVisible;
    });

    if (_isOverlayVisible) {
      _overlayController.forward();
    } else {
      _overlayController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  /// Handle back navigation with quick animation
  void _handleBackNavigation() async {
    // Quick overlay fade out
    await _overlayController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Handle page change in gallery mode
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    HapticFeedback.selectionClick();
  }

  /// Handle zoom state change for responsive UI
  void _onScaleEnd(PhotoViewControllerValue controllerValue) {
    // Simple zoom detection based on scale value
    final bool wasZoomed = _isZoomed;
    final bool isZoomed =
        controllerValue.scale != null && controllerValue.scale! > 1.1;

    if (wasZoomed != isZoomed) {
      setState(() {
        _isZoomed = isZoomed;
      });

      // Auto-hide overlay when zooming for better UX
      if (isZoomed && _isOverlayVisible) {
        _toggleOverlay();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: const Color(0xFF0A0A0C),
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            // Advanced gradient background for depth
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.black.withValues(alpha: 0.85),
                Colors.black.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background blur effect for glass morphism
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.black.withValues(alpha: 0.1)),
                ),
              ),

              // Main image gallery with photo_view
              _buildImageGallery(),

              // Top overlay with glass morphism app bar
              _buildTopOverlay(isDark),

              // Bottom overlay with image counter and controls
              if (widget.mediaPaths.length > 1) _buildBottomOverlay(isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main media gallery with photo_view and video player integration
  Widget _buildImageGallery() {
    if (widget.mediaPaths.length == 1) {
      // Single media mode
      final mediaPath = widget.mediaPaths[0];
      final isVideo = _isVideoFile(mediaPath);

      return GestureDetector(
        onTap: isVideo
            ? null
            : _toggleOverlay, // Videos handle their own tap controls
        child: widget.enableHeroAnimation && widget.heroTag != null
            ? Hero(
                tag: widget.heroTag!,
                child: isVideo
                    ? _buildVideoView(mediaPath)
                    : _buildPhotoView(mediaPath),
              )
            : isVideo
            ? _buildVideoView(mediaPath)
            : _buildPhotoView(mediaPath),
      );
    } else {
      // Gallery mode with swipe navigation - mix of images and videos
      return PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.mediaPaths.length,
        itemBuilder: (context, index) {
          final mediaPath = widget.mediaPaths[index];
          final isVideo = _isVideoFile(mediaPath);

          if (isVideo) {
            // Video item in gallery
            return _buildVideoView(
              mediaPath,
              heroTag: widget.enableHeroAnimation
                  ? '${widget.heroTag ?? 'media'}_$index'
                  : null,
            );
          } else {
            // Image item in gallery - use photo_view for zoom functionality
            return PhotoView(
              imageProvider: FileImage(File(mediaPath)),
              onTapUp: (context, details, controllerValue) => _toggleOverlay(),
              onScaleEnd: (context, details, controllerValue) {
                _onScaleEnd(controllerValue);
              },
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3.0,
              initialScale: PhotoViewComputedScale.contained,
              filterQuality: FilterQuality.high,
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              heroAttributes: widget.enableHeroAnimation
                  ? PhotoViewHeroAttributes(
                      tag: '${widget.heroTag ?? 'media'}_$index',
                    )
                  : null,
            );
          }
        },
      );
    }
  }

  /// Build photo view widget for single image
  Widget _buildPhotoView(String imagePath) {
    return PhotoView(
      imageProvider: FileImage(File(imagePath)),
      onTapUp: (context, details, controllerValue) => _toggleOverlay(),
      onScaleEnd: (context, details, controllerValue) {
        _onScaleEnd(controllerValue);
      },
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 3.0,
      initialScale: PhotoViewComputedScale.contained,
      filterQuality: FilterQuality.high,
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
    );
  }

  /// Build video view widget for video files
  Widget _buildVideoView(String videoPath, {String? heroTag}) {
    return PremiumVideoPlayer(
      videoPath: videoPath,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowFullscreen: true,
      heroTag: heroTag,
      onPlaybackComplete: () {
        AppLogger.userAction('Video playback completed in preview');
      },
      onPositionChanged: (position) {
        // Optional: Track video position for analytics
      },
    );
  }

  /// Build top overlay with glass morphism app bar
  Widget _buildTopOverlay(bool isDark) {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: _overlayAnimation.value,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                // Glass morphism gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: _buildTopControls(isDark),
            ),
          ),
        );
      },
    );
  }

  /// Build top control buttons with floating design
  Widget _buildTopControls(bool isDark) {
    return Row(
      children: [
        // Back button with glass morphism design
        _buildFloatingButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: _handleBackNavigation,
          isDark: isDark,
        ),
        const Spacer(),
        // Share button (if needed in future)
        // _buildFloatingButton(
        //   icon: Icons.share_rounded,
        //   onTap: () => _shareImage(),
        //   isDark: isDark,
        // ),
      ],
    );
  }

  /// Build bottom overlay with image counter for gallery mode
  Widget _buildBottomOverlay(bool isDark) {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: _overlayAnimation.value,
            child: Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              decoration: BoxDecoration(
                // Glass morphism gradient background
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: _buildImageCounter(isDark),
            ),
          ),
        );
      },
    );
  }

  /// Build media counter with modern design
  Widget _buildImageCounter(bool isDark) {
    final currentMediaPath = widget.mediaPaths[_currentIndex];
    final currentIsVideo = _isVideoFile(currentMediaPath);

    return Center(
      child: PremiumGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: 16,
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        blur: 15,
        hasShadow: false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              currentIsVideo ? Icons.videocam_rounded : Icons.image_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              '${_currentIndex + 1} / ${widget.mediaPaths.length}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build floating action button with glass morphism (matching app bar style)
  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }
}
