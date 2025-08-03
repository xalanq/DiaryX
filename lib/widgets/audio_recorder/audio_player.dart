import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';
import '../../themes/app_colors.dart';
import '../../utils/app_logger.dart';
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

  void _loadAudioInfo() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _audioService.initialize();
      _duration = await _audioService.getAudioDuration(widget.audioPath);
      AppLogger.info(
        'Audio duration loaded: $_duration for ${widget.audioPath}',
      );
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
  void dispose() {
    _playController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _playPause() async {
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
    }
  }

  Future<void> _playAudio() async {
    setState(() => _isLoading = true);

    try {
      await _audioService.playAudio(widget.audioPath);

      setState(() {
        _isPlaying = _audioService.isPlaying;
        _isLoading = false;
        _position = _audioService.playbackPosition;
        _duration = _audioService.totalDuration;
      });

      _playController.forward();
      _startProgressTimer();
      widget.onPlayStateChanged?.call(true);

      AppLogger.info('Started playing audio: ${widget.audioPath}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to play audio';
      });
      rethrow;
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioService.pauseAudio();

      setState(() => _isPlaying = _audioService.isPlaying);
      _playController.reverse();
      _stopProgressTimer();
      widget.onPlayStateChanged?.call(false);

      AppLogger.info('Paused audio: ${widget.audioPath}');
    } catch (e) {
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

          // 确保position不超过duration
          if (_duration.inMilliseconds > 0 &&
              _position.inMilliseconds > _duration.inMilliseconds) {
            _position = _duration;
          }
        });
      } else {
        _stopProgressTimer();
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  void _seekTo(double value) async {
    if (_duration.inMilliseconds > 0) {
      final newPosition = Duration(
        milliseconds: (value * _duration.inMilliseconds).round(),
      );

      try {
        await _audioService.seekTo(newPosition);
        setState(() => _position = newPosition);
        AppLogger.debug('Seeked to: $newPosition');
      } catch (e) {
        AppLogger.error('Failed to seek audio', e);
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0.0;
    final progress = _position.inMilliseconds / _duration.inMilliseconds;
    return progress.clamp(0.0, 1.0); // 确保值在有效范围内
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
