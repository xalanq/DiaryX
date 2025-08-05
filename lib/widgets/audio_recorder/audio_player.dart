import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';
import '../../themes/app_colors.dart';
import '../../utils/app_logger.dart';
import '../../utils/snackbar_helper.dart';
import '../premium_glass_card/premium_glass_card.dart';

/// Premium audio player widget with glass morphism design
class PremiumAudioPlayer extends StatefulWidget {
  const PremiumAudioPlayer({
    super.key,
    required this.audioPath,
    this.onPlayStateChanged,
    this.showDuration = true,
    this.autoPlay = false,
  });

  final String audioPath;
  final Function(bool isPlaying)? onPlayStateChanged;
  final bool showDuration;
  final bool autoPlay;

  @override
  State<PremiumAudioPlayer> createState() => _PremiumAudioPlayerState();
}

class _PremiumAudioPlayerState extends State<PremiumAudioPlayer>
    with TickerProviderStateMixin {
  late final AudioService _audioService;
  late final AnimationController _playController;
  late final AnimationController _progressController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;

  Timer? _progressTimer;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _error;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _initializeAnimations();
    _loadAudioInfo();

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playPause());
    }
  }

  void _initializeAnimations() {
    _playController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _playController, curve: Curves.easeInOut),
    );
  }

  void _resetPlayerState() async {
    // Stop current playback if playing
    if (_isPlaying) {
      try {
        await _audioService.pauseAudio();
      } catch (e) {
        AppLogger.debug('Failed to pause audio during reset: $e');
      }
    }

    // Reset UI state
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _isLoading = false;
        _duration = Duration.zero;
        _position = Duration.zero;
        _error = null;
      });
    }

    // Reset animations
    _playController.reset();
    _progressController.reset();
    _stopProgressTimer();

    // Notify parent about play state change
    widget.onPlayStateChanged?.call(false);
  }

  void _loadAudioInfo() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Check if audio file exists
      final audioFile = File(widget.audioPath);
      if (!await audioFile.exists()) {
        setState(() {
          _error = 'Audio file not found';
          _isLoading = false;
        });
        AppLogger.warn('Audio file does not exist: ${widget.audioPath}');
        return;
      }

      await _audioService.initialize();

      // Retry loading duration with exponential backoff
      Duration? loadedDuration;
      int retryCount = 0;
      const maxRetries = 5;

      while (retryCount < maxRetries && mounted) {
        loadedDuration = await _audioService.getAudioDuration(widget.audioPath);

        if (loadedDuration.inMilliseconds > 0) {
          _duration = loadedDuration;
          AppLogger.info(
            'Audio duration loaded: $_duration for ${widget.audioPath} (attempt ${retryCount + 1})',
          );
          break;
        }

        retryCount++;
        if (retryCount < maxRetries) {
          // Wait before retrying, with exponential backoff
          await Future.delayed(Duration(milliseconds: 200 * retryCount));
          AppLogger.debug(
            'Retrying audio duration load (attempt ${retryCount + 1}/$maxRetries)',
          );
        }
      }

      if (loadedDuration == null || loadedDuration.inMilliseconds == 0) {
        AppLogger.warn(
          'Could not load audio duration after $maxRetries attempts',
        );
      }
    } catch (e) {
      _error = 'Failed to load audio file';
      AppLogger.error('Failed to load audio info', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void didUpdateWidget(PremiumAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If audio path changed, reload audio info
    if (oldWidget.audioPath != widget.audioPath) {
      _resetPlayerState();
      _loadAudioInfo();
    }
  }

  @override
  void dispose() {
    _playController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _playPause() async {
    // Prevent multiple simultaneous operations
    if (_isLoading) return;

    try {
      HapticFeedback.lightImpact();

      if (_isPlaying) {
        await _pauseAudio();
      } else {
        await _playAudio();
      }
    } catch (e) {
      AppLogger.error('Failed to play/pause audio', e);
      _showErrorSnackBar('Failed to play audio');

      // Ensure loading state is reset on error
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _playAudio() async {
    if (_isLoading) return; // Additional safety check

    setState(() => _isLoading = true);

    try {
      // Double-check if file still exists before playing
      final audioFile = File(widget.audioPath);
      if (!await audioFile.exists()) {
        if (mounted) {
          setState(() {
            _error = 'Audio file not found';
            _isLoading = false;
          });
        }
        AppLogger.warn(
          'Audio file missing during playback: ${widget.audioPath}',
        );
        return;
      }

      // If at end of track, restart from beginning
      // Note: After completion, seekTo might fail, so we stop and restart
      if (_duration.inMilliseconds > 0 &&
          _position.inMilliseconds >= _duration.inMilliseconds) {
        try {
          // Stop current audio completely to reset the player state
          await _audioService.stopAudio();
          AppLogger.debug('Stopped audio for restart');
        } catch (e) {
          AppLogger.debug('Failed to stop audio before restart: $e');
        }

        // Reset position in UI immediately
        if (mounted) {
          setState(() => _position = Duration.zero);
        }

        // Small delay to ensure player state is reset
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await _audioService.playAudio(widget.audioPath);

      if (mounted) {
        setState(() {
          _isPlaying = _audioService.isPlaying;
          _isLoading = false;
          _position = _audioService.playbackPosition;
          _duration = _audioService.totalDuration;
        });
      }

      _playController.forward();
      _startProgressTimer();
      widget.onPlayStateChanged?.call(true);

      AppLogger.info('Started playing audio: ${widget.audioPath}');
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to play audio';
        });
      }
      rethrow;
    }
  }

  Future<void> _pauseAudio() async {
    if (_isLoading) return; // Additional safety check

    // Set loading for visual feedback
    setState(() => _isLoading = true);

    try {
      await _audioService.pauseAudio();

      if (mounted) {
        setState(() {
          _isPlaying = _audioService.isPlaying;
          _isLoading = false;
        });
      }

      _playController.reverse();
      _stopProgressTimer();
      widget.onPlayStateChanged?.call(false);

      AppLogger.info('Paused audio: ${widget.audioPath}');
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      rethrow;
    }
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_audioService.isPlaying) {
        setState(() {
          _position = _audioService.playbackPosition;
          _duration = _audioService.totalDuration;
          _isPlaying = _audioService.isPlaying;

          // Ensure position doesn't exceed duration
          if (_duration.inMilliseconds > 0 &&
              _position.inMilliseconds > _duration.inMilliseconds) {
            _position = _duration;
          }
        });

        // Check if playback has completed
        if (_duration.inMilliseconds > 0 &&
            _position.inMilliseconds >= _duration.inMilliseconds) {
          _onPlaybackCompleted();
        }
      } else {
        // Audio service is no longer playing, update UI accordingly
        setState(() {
          _isPlaying = false;
        });
        _playController.reverse();
        widget.onPlayStateChanged?.call(false);
        _stopProgressTimer();
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  void _onPlaybackCompleted() async {
    AppLogger.info('Audio playback completed: ${widget.audioPath}');

    // Stop the audio service to ensure clean state
    try {
      await _audioService.stopAudio();
    } catch (e) {
      AppLogger.debug('Failed to stop audio on completion: $e');
    }

    if (mounted) {
      setState(() {
        _isPlaying = false;
        _isLoading = false; // Ensure loading state is reset
        _position = _duration; // Keep at end to show completion
      });
    }

    // Update animations and notify parent
    _playController.reverse();
    _stopProgressTimer();
    widget.onPlayStateChanged?.call(false);

    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _seekTo(double value) async {
    if (_duration.inMilliseconds > 0) {
      final newPosition = Duration(
        milliseconds: (value * _duration.inMilliseconds).round(),
      );

      try {
        // If audio was completed and we're seeking, need to restart playback
        if (_position.inMilliseconds >= _duration.inMilliseconds &&
            !_isPlaying) {
          // Reset audio state first
          await _audioService.stopAudio();
          await Future.delayed(const Duration(milliseconds: 50));
          // Set the source again
          await _audioService.playAudio(widget.audioPath);
          // Immediately pause to allow seeking
          await _audioService.pauseAudio();
        }

        await _audioService.seekTo(newPosition);
        if (mounted) {
          setState(() => _position = newPosition);
        }
        AppLogger.debug('Seeked to: $newPosition');
      } catch (e) {
        AppLogger.error('Failed to seek audio', e);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      SnackBarHelper.showError(context, message);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    final progress = _position.inMilliseconds / _duration.inMilliseconds;
    return progress.clamp(0.0, 1.0); // Ensure value is within valid range
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_error != null) {
      return PremiumGlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red.shade400,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _error!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.red.shade400,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PremiumGlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Play/Pause button
          GestureDetector(
            onTapDown: (_) => _progressController.forward(),
            onTapUp: (_) => _progressController.reverse(),
            onTapCancel: () => _progressController.reverse(),
            onTap: _isLoading ? null : _playPause,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          isDark
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          )
                        : AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationAnimation.value * 0.1,
                                child: Icon(
                                  _isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 16),

          // Progress and duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 12,
                    ),
                    activeTrackColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    inactiveTrackColor:
                        (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.3),
                    thumbColor: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    overlayColor:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: _progress,
                    onChanged: _seekTo,
                    onChangeEnd: (_) => HapticFeedback.lightImpact(),
                  ),
                ),

                // Duration display
                if (widget.showDuration) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_position),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
