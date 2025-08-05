import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../utils/app_logger.dart';
import '../../themes/app_colors.dart';

/// Premium video player widget with glass morphism controls and modern UI
class PremiumVideoPlayer extends StatefulWidget {
  final String videoPath;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowFullscreen;
  final double bottomShift;
  final double topShift;
  final VoidCallback? onPlaybackComplete;
  final Function(Duration)? onPositionChanged;
  final String? heroTag;

  const PremiumVideoPlayer({
    super.key,
    required this.videoPath,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowFullscreen = true,
    this.bottomShift = 0,
    this.topShift = 0,
    this.onPlaybackComplete,
    this.onPositionChanged,
    this.heroTag,
  });

  @override
  State<PremiumVideoPlayer> createState() => _PremiumVideoPlayerState();
}

class _PremiumVideoPlayerState extends State<PremiumVideoPlayer>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  late AnimationController _controlsController;
  late AnimationController _playButtonController;
  late Animation<double> _controlsAnimation;
  late Animation<double> _playButtonAnimation;

  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isControlsVisible = true;
  bool _hasError = false;
  String? _errorMessage;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideo();
  }

  void _initializeAnimations() {
    _controlsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _playButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _controlsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controlsController, curve: Curves.easeInOut),
    );

    _playButtonAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _playButtonController, curve: Curves.easeInOut),
    );

    // Start with controls visible
    _controlsController.forward();
  }

  Future<void> _initializeVideo() async {
    try {
      AppLogger.info('Starting video initialization: ${widget.videoPath}');

      // Check if file exists for local videos
      if (!widget.videoPath.startsWith('http')) {
        final file = File(widget.videoPath);
        if (!await file.exists()) {
          throw Exception('Video file does not exist: ${widget.videoPath}');
        }
        AppLogger.info('Video file exists, size: ${await file.length()} bytes');
      }

      if (widget.videoPath.startsWith('http')) {
        // Network video
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoPath),
        );
        AppLogger.info('Created network video controller');
      } else {
        // Local file video
        _controller = VideoPlayerController.file(File(widget.videoPath));
        AppLogger.info('Created file video controller');
      }

      AppLogger.info('Initializing video controller...');
      await _controller!.initialize();
      AppLogger.info('Video controller initialized successfully');

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _duration = _controller!.value.duration;
        });

        AppLogger.info('Video duration: ${_duration.toString()}');

        // Set up listeners
        _controller!.addListener(_videoListener);

        // Auto play if enabled
        if (widget.autoPlay) {
          AppLogger.info('Auto-playing video');
          _togglePlayPause();
        }

        AppLogger.info('Video initialized successfully');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize video', e, stackTrace);
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = 'Failed to load video: $e';
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && mounted) {
      final value = _controller!.value;
      final position = value.position;
      final duration = value.duration;
      final isPlaying = value.isPlaying;
      final hasError = value.hasError;

      // Check for errors
      if (hasError) {
        AppLogger.error('Video player error: ${value.errorDescription}');
        setState(() {
          _hasError = true;
          _errorMessage = value.errorDescription ?? 'Unknown video error';
        });
        return;
      }

      if (_position != position) {
        setState(() {
          _position = position;
        });
        widget.onPositionChanged?.call(position);
      }

      if (_duration != duration) {
        setState(() {
          _duration = duration;
        });
        AppLogger.info('Video duration updated: $duration');
      }

      if (_isPlaying != isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
        AppLogger.info('Video playing state changed: $isPlaying');
      }

      // Check if video ended
      if (position >= duration && duration.inMilliseconds > 0) {
        AppLogger.info('Video playback completed');
        widget.onPlaybackComplete?.call();

        if (!widget.looping) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    }
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) {
      AppLogger.warn(
        'Cannot toggle play/pause: controller=${_controller != null}, initialized=$_isInitialized',
      );
      return;
    }

    HapticFeedback.lightImpact();

    try {
      if (_isPlaying) {
        AppLogger.info('Pausing video');
        _controller!.pause();
      } else {
        AppLogger.info('Playing video');
        _controller!.play();
      }

      // Trigger button animation for visual feedback
      _playButtonController.forward().then((_) {
        _playButtonController.reverse();
      });
    } catch (e) {
      AppLogger.error('Error toggling play/pause', e);
    }
  }

  void _seekTo(double value) {
    if (_controller == null || !_isInitialized) return;

    final position = Duration(
      milliseconds: (value * _duration.inMilliseconds).round(),
    );
    _controller!.seekTo(position);

    HapticFeedback.selectionClick();
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });

    if (_isControlsVisible) {
      _controlsController.forward();
    } else {
      _controlsController.reverse();
    }

    HapticFeedback.lightImpact();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _controlsController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorView();
    }

    if (!_isInitialized) {
      return _buildLoadingView();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video player
          _buildVideoPlayer(),

          // Tap detector for showing/hiding controls (behind play button)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleControls,
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),

          // Controls overlay
          if (widget.showControls) _buildControlsOverlay(),

          // Play button overlay (when paused) - on top so it can receive clicks
          if (!_isPlaying) _buildPlayButtonOverlay(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return widget.heroTag != null
        ? Hero(tag: widget.heroTag!, child: VideoPlayer(_controller!))
        : VideoPlayer(_controller!);
  }

  Widget _buildPlayButtonOverlay() {
    return AnimatedBuilder(
      animation: _playButtonAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _playButtonAnimation.value,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.3),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlsOverlay() {
    return AnimatedBuilder(
      animation: _controlsAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _controlsAnimation.value,
          child: Column(
            children: [
              // Top controls
              Container(
                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context).padding.top + 16 + widget.topShift,
                  left: 8,
                  right: 8,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    // Duration display
                    PremiumGlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      borderRadius: 12,
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                      blur: 10,
                      hasShadow: false,
                      child: Text(
                        '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bottom controls
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom:
                      MediaQuery.of(context).padding.bottom +
                      20 +
                      widget.bottomShift,
                ),
                child: PremiumGlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  borderRadius: 24,
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  blur: 15,
                  hasShadow: false,
                  child: Row(
                    children: [
                      // Play/Pause button on the left
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.darkTextPrimary.withValues(
                              alpha: 0.9,
                            ),
                          ),
                          child: Icon(
                            _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Progress bar (expanded to fill remaining space)
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.darkTextPrimary,
                            inactiveTrackColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            thumbColor: AppColors.darkTextPrimary,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 16,
                            ),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _duration.inMilliseconds > 0
                                ? _position.inMilliseconds /
                                      _duration.inMilliseconds
                                : 0.0,
                            onChanged: _seekTo,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              Text(
                'Video Error',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Failed to load video',
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = null;
                    _isInitialized = false;
                  });
                  _initializeVideo();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
