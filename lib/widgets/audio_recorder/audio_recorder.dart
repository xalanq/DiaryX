import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/audio_service.dart';
import '../../themes/app_colors.dart';
import '../../utils/app_logger.dart';
import '../../routes.dart';
import '../../utils/snackbar_helper.dart';
import '../premium_glass_card/premium_glass_card.dart';

/// Premium audio recorder widget with glass morphism design
class PremiumAudioRecorder extends StatefulWidget {
  const PremiumAudioRecorder({
    super.key,
    this.onRecordingComplete,
    this.onRecordingStart,
    this.maxDuration,
    this.showWaveform = true,
  });

  final Function(String filePath, Duration duration)? onRecordingComplete;
  final VoidCallback? onRecordingStart;
  final Duration? maxDuration; // 允许为null，表示无时长限制
  final bool showWaveform;

  @override
  State<PremiumAudioRecorder> createState() => PremiumAudioRecorderState();
}

/// Global key type for accessing PremiumAudioRecorder state
typedef PremiumAudioRecorderKey = GlobalKey<PremiumAudioRecorderState>;

class PremiumAudioRecorderState extends State<PremiumAudioRecorder>
    with TickerProviderStateMixin {
  late final AudioService _audioService;
  late final AnimationController _pulseController;
  late final AnimationController _waveController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _scaleAnimation;

  Timer? _durationTimer;
  Timer? _amplitudeTimer;
  Duration _currentDuration = Duration.zero;
  final List<double> _waveformData = [];
  String? _recordingPath;
  bool _hasPermission = false;

  /// 重置录音组件状态
  void resetState() {
    _stopTimers();
    setState(() {
      _currentDuration = Duration.zero;
      _waveformData.clear();
      _recordingPath = null;
    });
    AppLogger.debug('Audio recorder state reset');
  }

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _initializeAnimations();
    _initializeAudioService();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.elasticOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _initializeAudioService() async {
    try {
      await _audioService.initialize();
      _hasPermission = await _audioService.requestPermission();
      setState(() {});
    } catch (e) {
      AppLogger.error('Failed to initialize audio service', e);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _durationTimer?.cancel();
    _amplitudeTimer?.cancel();
    super.dispose();
  }

  void _startRecording() async {
    try {
      HapticFeedback.mediumImpact();

      if (!_hasPermission) {
        _hasPermission = await _audioService.requestPermission();
        if (!_hasPermission) {
          _showPermissionDialog();
          return;
        }
      }

      _recordingPath = await _audioService.startRecording();

      if (_recordingPath != null) {
        setState(() {
          _currentDuration = Duration.zero;
          _waveformData.clear();
        });

        widget.onRecordingStart?.call();
        _startTimers();
        AppLogger.info('Recording started: $_recordingPath');
      }
    } catch (e) {
      AppLogger.error('Failed to start recording', e);
      _showErrorSnackBar('Failed to start recording');
    }
  }

  void _stopRecording() async {
    try {
      HapticFeedback.lightImpact();

      final path = await _audioService.stopRecording();
      _stopTimers();

      // Save current duration for callback
      final recordedDuration = _currentDuration;

      // Update internal state first to ensure UI responds immediately
      setState(() {
        _recordingPath = null;
        _currentDuration = Duration.zero;
        _waveformData.clear();
      });

      // Call callback with saved duration - more lenient condition for very short recordings
      if (path != null && recordedDuration.inMilliseconds > 100) {
        widget.onRecordingComplete?.call(path, recordedDuration);
        AppLogger.info(
          'Recording completed: $path, Duration: $recordedDuration',
        );
      } else {
        // Log when callback is not triggered
        AppLogger.warn(
          'Recording callback not triggered: path=$path, duration=$recordedDuration',
        );
        // Still show error to user if path is null
        if (path == null) {
          _showErrorSnackBar('Recording failed - no audio file created');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to stop recording', e);
      _showErrorSnackBar('Failed to stop recording');

      // Ensure state is reset even on error
      setState(() {
        _recordingPath = null;
        _currentDuration = Duration.zero;
        _waveformData.clear();
      });
    }
  }

  void _startTimers() {
    // Duration timer
    _durationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _currentDuration = Duration(
          milliseconds: _currentDuration.inMilliseconds + 100,
        );

        // Stop recording if max duration reached (only if maxDuration is set)
        if (widget.maxDuration != null &&
            _currentDuration >= widget.maxDuration!) {
          _stopRecording();
        }
      });
    });

    // Amplitude timer for waveform
    if (widget.showWaveform) {
      _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 30), (
        timer,
      ) async {
        if (_audioService.isRecording) {
          final amplitude = await _audioService.getAmplitude();
          if (!mounted) {
            return;
          }

          setState(() {
            _waveformData.add(amplitude);
            // Keep only last 30 values for left side of reference line (滚动效果)
            if (_waveformData.length > 30) {
              _waveformData.removeAt(0);
            }
          });

          // 只在有明显音量变化时记录调试信息
          if (kDebugMode && amplitude > 0.2) {
            AppLogger.debug(
              'Waveform: ${(amplitude * 100).toStringAsFixed(0)}%',
            );
          }
        }
      });
    }
  }

  void _stopTimers() {
    _durationTimer?.cancel();
    _amplitudeTimer?.cancel();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Required'),
        content: const Text(
          'DiaryX needs microphone access to record voice moments. Please grant permission in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => AppRoutes.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              AppRoutes.pop(context);
              // TODO: Open app settings
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
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

  List<double> _generatePlaceholderWaveform() {
    // Generate a placeholder pattern with low consistent amplitude for left side
    final data = <double>[];
    for (int i = 0; i < 15; i++) {
      // Low amplitude placeholder (just visible background bars)
      data.add(0.1);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRecording = _audioService.isRecording;

    return PremiumGlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Recording duration display - always present to maintain consistent height
          SizedBox(
            height: 40, // Fixed height for duration area
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  ),
                );
              },
              child: isRecording
                  ? Text(
                      key: const ValueKey('duration'),
                      _formatDuration(_currentDuration),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(
                      key: const ValueKey('placeholder'),
                      // Transparent placeholder to maintain height
                    ),
            ),
          ),
          const SizedBox(
            height: 16,
          ), // Consistent spacing regardless of recording state
          // Waveform visualization
          if (widget.showWaveform) ...[
            SizedBox(
              height: 60,
              child: AnimatedBuilder(
                animation: _waveController,
                child: WaveformVisualizer(
                  data: isRecording
                      ? _waveformData
                      : _generatePlaceholderWaveform(),
                  color: isDark
                      ? AppColors.darkPrimary.withValues(
                          alpha: isRecording ? 1.0 : 0.3,
                        )
                      : AppColors.lightPrimary.withValues(
                          alpha: isRecording ? 1.0 : 0.3,
                        ),
                ),
                builder: (context, child) =>
                    Transform.scale(scale: _scaleAnimation.value, child: child),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Recording button with smooth transitions
          GestureDetector(
            onTapDown: (_) => _waveController.forward(),
            onTapUp: (_) => _waveController.reverse(),
            onTapCancel: () => _waveController.reverse(),
            onTap: isRecording ? _stopRecording : _startRecording,
            child: AnimatedBuilder(
              animation: isRecording ? _pulseAnimation : _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording
                      ? _pulseAnimation.value
                      : _scaleAnimation.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isRecording
                            ? [Colors.red.shade400, Colors.red.shade600]
                            : [
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
                              (isRecording
                                      ? Colors.red
                                      : (isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary))
                                  .withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return RotationTransition(
                              turns: animation,
                              child: child,
                            );
                          },
                      child: Icon(
                        key: ValueKey(isRecording),
                        isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Hint text - consistent height area
          SizedBox(
            height: 40, // Fixed height for hint text area
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey(isRecording),
                  isRecording
                      ? 'Tap to stop recording'
                      : 'Tap to start recording your voice moment. There\'s no time limit.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary)
                            .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),

          // Max duration indicator placeholder - maintain consistent height
          SizedBox(
            height: 30, // Fixed height for bottom area
            child: !isRecording && widget.maxDuration != null
                ? Center(
                    child: Text(
                      'Max duration: ${_formatDuration(widget.maxDuration!)}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary)
                                .withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : Container(), // Empty placeholder when not needed
          ),
        ],
      ),
    );
  }
}

/// Waveform visualization widget
class WaveformVisualizer extends StatelessWidget {
  const WaveformVisualizer({
    super.key,
    required this.data,
    required this.color,
  });

  final List<double> data;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(data: data, color: color),
      size: const Size(double.infinity, 60),
    );
  }
}

/// Custom painter for waveform visualization
class WaveformPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  WaveformPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final barCount = 60; // 固定数量的竖线
    final barWidth = 2.0; // 竖线宽度
    final barSpacing = size.width / barCount; // 竖线间距
    final centerX = size.width / 2; // 中心线位置

    // 只在调试模式下且数据变化时记录
    if (kDebugMode && data.length % 10 == 0) {
      AppLogger.debug('Waveform paint: ${data.length} points');
    }

    // 绘制背景竖线（较暗）
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    // 绘制所有背景竖线
    for (int i = 0; i < barCount; i++) {
      final x = i * barSpacing + barSpacing / 2;
      final minHeight = size.height * 0.05; // 更小的背景高度，与活跃竖线一致

      canvas.drawLine(
        Offset(x, centerY - minHeight / 2),
        Offset(x, centerY + minHeight / 2),
        backgroundPaint,
      );
    }

    // 绘制活跃竖线（根据音频数据）
    final activePaint = Paint()
      ..color = color
      ..strokeWidth = barWidth
      ..strokeCap = StrokeCap.round;

    // 如果有数据，绘制对应的竖线（只在参考线左侧）
    if (data.isNotEmpty) {
      final leftBarsCount = barCount ~/ 2; // 参考线左侧的竖线数量
      final dataToShow = data.length > leftBarsCount
          ? data.sublist(data.length - leftBarsCount)
          : data;

      for (int i = 0; i < dataToShow.length; i++) {
        final amplitude = dataToShow[i].clamp(0.0, 1.0);

        // 使用平方映射进一步增强高音量的可见性
        final enhancedAmplitude = amplitude * amplitude;

        // 增加高度范围到85%，让差异更明显
        final barHeight = enhancedAmplitude * size.height * 0.85;
        final minHeight = size.height * 0.05; // 减小最小高度
        final actualHeight = math.max(barHeight, minHeight);

        // 从参考线左边开始放置数据（最新数据靠近参考线）
        final barIndex = leftBarsCount - dataToShow.length + i;
        final x = barIndex * barSpacing + barSpacing / 2;

        // 只绘制参考线左侧的竖线
        if (x < centerX) {
          canvas.drawLine(
            Offset(x, centerY - actualHeight / 2),
            Offset(x, centerY + actualHeight / 2),
            activePaint,
          );
        }
      }
    }

    // 绘制中心参考线（高亮）
    final centerLinePaint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(centerX, size.height * 0.1),
      Offset(centerX, size.height * 0.9),
      centerLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
