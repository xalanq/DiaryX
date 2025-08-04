import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../utils/app_logger.dart';

/// Premium image preview screen with advanced glass morphism design
/// Supports single image and gallery mode with modern UI/UX elements
class PremiumImagePreview extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final String? heroTag;
  final bool enableHeroAnimation;

  const PremiumImagePreview({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
    this.heroTag,
    this.enableHeroAnimation = true,
  });

  /// Show single image preview with hero animation
  static Future<void> showSingle(
    BuildContext context,
    String imagePath, {
    String? heroTag,
    bool enableHeroAnimation = true,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PremiumImagePreview(
              imagePaths: [imagePath],
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

  /// Show gallery mode with multiple images
  static Future<void> showGallery(
    BuildContext context,
    List<String> imagePaths, {
    int initialIndex = 0,
    String? heroTag,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PremiumImagePreview(
              imagePaths: imagePaths,
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

    AppLogger.userAction('Image preview opened', {
      'imageCount': widget.imagePaths.length,
      'initialIndex': widget.initialIndex,
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

    return Scaffold(
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
            if (widget.imagePaths.length > 1) _buildBottomOverlay(isDark),
          ],
        ),
      ),
    );
  }

  /// Build the main image gallery with photo_view integration
  Widget _buildImageGallery() {
    if (widget.imagePaths.length == 1) {
      // Single image mode
      return GestureDetector(
        onTap: _toggleOverlay,
        child: widget.enableHeroAnimation && widget.heroTag != null
            ? Hero(
                tag: widget.heroTag!,
                child: _buildPhotoView(widget.imagePaths[0]),
              )
            : _buildPhotoView(widget.imagePaths[0]),
      );
    } else {
      // Gallery mode with swipe navigation
      return PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.imagePaths.length,
        onPageChanged: _onPageChanged,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: FileImage(File(widget.imagePaths[index])),
            onTapUp: (context, details, controllerValue) => _toggleOverlay(),
            onScaleEnd: (context, details, controllerValue) {
              _onScaleEnd(controllerValue);
            },
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3.0,
            initialScale: PhotoViewComputedScale.contained,
            filterQuality: FilterQuality.high,
            // Smooth hero animation for gallery items
            heroAttributes: widget.enableHeroAnimation
                ? PhotoViewHeroAttributes(
                    tag: '${widget.heroTag ?? 'image'}_$index',
                  )
                : null,
          );
        },
        // Smooth page transitions with elastic curve
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
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
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 16,
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
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
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

  /// Build image counter with modern design
  Widget _buildImageCounter(bool isDark) {
    return Center(
      child: PremiumGlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 16,
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        blur: 15,
        hasShadow: false,
        child: Text(
          '${_currentIndex + 1} / ${widget.imagePaths.length}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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
