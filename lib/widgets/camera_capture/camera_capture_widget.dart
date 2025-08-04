import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import '../../services/camera_service.dart';
import '../../themes/app_colors.dart';
import '../../utils/app_logger.dart';
import '../premium_glass_card/premium_glass_card.dart';

/// Premium camera capture widget with glass morphism design
class CameraCaptureWidget extends StatefulWidget {
  const CameraCaptureWidget({
    super.key,
    this.onPhotoTaken,
    this.onVideoRecorded,
    this.initialCameraDirection = CameraLensDirection.back,
    this.resolutionPreset = ResolutionPreset.high,
  });

  final Function(String filePath)? onPhotoTaken;
  final Function(String filePath, Duration duration)? onVideoRecorded;
  final CameraLensDirection initialCameraDirection;
  final ResolutionPreset resolutionPreset;

  @override
  State<CameraCaptureWidget> createState() => _CameraCaptureWidgetState();
}

class _CameraCaptureWidgetState extends State<CameraCaptureWidget>
    with TickerProviderStateMixin {
  final CameraService _cameraService = CameraService.instance;
  CameraController? _controller;

  late AnimationController _recordingController;
  late AnimationController _flashController;
  late Animation<double> _recordingAnimation;
  late Animation<double> _flashAnimation;

  bool _isInitializing = true;
  bool _isRecording = false;
  bool _flashEnabled = false;
  String? _error;
  DateTime? _recordingStartTime;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeCamera();
  }

  void _initializeAnimations() {
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _flashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _recordingAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _recordingController, curve: Curves.easeInOut),
    );

    _flashAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _flashController, curve: Curves.easeOut));
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();

      _controller = await _cameraService.initializeCamera(
        direction: widget.initialCameraDirection,
        resolution: widget.resolutionPreset,
      );

      if (_controller != null) {
        setState(() {
          _isInitializing = false;
        });
        AppLogger.info('Camera initialized successfully');
      } else {
        setState(() {
          _error = 'Failed to initialize camera';
          _isInitializing = false;
        });
      }
    } catch (e) {
      AppLogger.error('Camera initialization failed', e);
      setState(() {
        _error = 'Camera initialization failed: $e';
        _isInitializing = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    if (_controller == null) return;

    try {
      HapticFeedback.lightImpact();

      // Flash animation
      _flashController.forward().then((_) {
        _flashController.reverse();
      });

      final String? photoPath = await _cameraService.takePhoto();

      if (photoPath != null && widget.onPhotoTaken != null) {
        widget.onPhotoTaken!(photoPath);
        AppLogger.userAction('Photo taken successfully');
      }
    } catch (e) {
      AppLogger.error('Failed to take photo', e);
      _showError('Failed to take photo');
    }
  }

  Future<void> _toggleVideoRecording() async {
    if (_controller == null) return;

    try {
      if (_isRecording) {
        // Stop recording
        final String? videoPath = await _cameraService.stopVideoRecording();

        if (videoPath != null && widget.onVideoRecorded != null) {
          final duration = _recordingStartTime != null
              ? DateTime.now().difference(_recordingStartTime!)
              : Duration.zero;
          widget.onVideoRecorded!(videoPath, duration);
        }

        _recordingController.stop();
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });

        AppLogger.userAction('Video recording stopped');
      } else {
        // Start recording
        await _cameraService.startVideoRecording();

        _recordingController.repeat(reverse: true);
        setState(() {
          _isRecording = true;
          _recordingStartTime = DateTime.now();
        });

        AppLogger.userAction('Video recording started');
      }

      HapticFeedback.mediumImpact();
    } catch (e) {
      AppLogger.error('Failed to toggle video recording', e);
      _showError('Failed to record video');
    }
  }

  Future<void> _switchCamera() async {
    if (_controller == null) return;

    try {
      final currentDirection = _controller!.description.lensDirection;
      final newDirection = currentDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;

      await _cameraService.disposeCamera();

      _controller = await _cameraService.initializeCamera(
        direction: newDirection,
        resolution: widget.resolutionPreset,
      );

      setState(() {});
      HapticFeedback.selectionClick();
      AppLogger.userAction('Camera switched');
    } catch (e) {
      AppLogger.error('Failed to switch camera', e);
      _showError('Failed to switch camera');
    }
  }

  void _toggleFlash() {
    if (_controller == null) return;

    setState(() {
      _flashEnabled = !_flashEnabled;
    });

    _controller!.setFlashMode(_flashEnabled ? FlashMode.torch : FlashMode.off);

    HapticFeedback.selectionClick();
    AppLogger.userAction('Flash toggled: $_flashEnabled');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _recordingController.dispose();
    _flashController.dispose();
    _cameraService.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return _buildLoadingView();
    }

    if (_error != null) {
      return _buildErrorView();
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return _buildLoadingView();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        _buildCameraPreview(),

        // Flash overlay
        AnimatedBuilder(
          animation: _flashAnimation,
          builder: (context, child) {
            return Container(
              color: Colors.white.withValues(
                alpha: _flashAnimation.value * 0.8,
              ),
            );
          },
        ),

        // Controls overlay
        _buildControlsOverlay(),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return CameraPreview(_controller!);
  }

  Widget _buildControlsOverlay() {
    return Column(
      children: [
        // Top controls
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flash toggle
                _buildControlButton(
                  icon: _flashEnabled ? Icons.flash_on : Icons.flash_off,
                  onTap: _toggleFlash,
                  isActive: _flashEnabled,
                ),

                // Recording indicator
                if (_isRecording) _buildRecordingIndicator(),

                // Camera switch
                _buildControlButton(
                  icon: Icons.flip_camera_ios,
                  onTap: _switchCamera,
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Bottom controls
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: AnimatedBuilder(
                animation: _recordingAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRecording ? _recordingAnimation.value : 1.0,
                    child: GestureDetector(
                      onTap: _takePhoto,
                      onLongPress: _toggleVideoRecording,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording ? Colors.red : Colors.white,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.camera_alt,
                          color: _isRecording ? Colors.white : Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return PremiumGlassCard(
      padding: const EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          icon,
          color: isActive ? AppColors.lightPrimary : Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return PremiumGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          StreamBuilder<int>(
            stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
            builder: (context, snapshot) {
              final duration = _recordingStartTime != null
                  ? DateTime.now().difference(_recordingStartTime!)
                  : Duration.zero;

              final minutes = duration.inMinutes.toString().padLeft(2, '0');
              final seconds = (duration.inSeconds % 60).toString().padLeft(
                2,
                '0',
              );

              return Text(
                '$minutes:$seconds',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Camera error',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
