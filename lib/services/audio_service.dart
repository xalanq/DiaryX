import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/app_logger.dart';

/// Audio recording service that handles voice recording, playback, and file management
class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  // Recording state
  bool _isRecording = false;
  bool _isPaused = false;
  String? _currentRecordingPath;
  Duration _recordingDuration = Duration.zero;

  // Playback state
  bool _isPlaying = false;
  String? _currentPlayingPath;
  Duration _playbackPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Getters
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  String? get currentRecordingPath => _currentRecordingPath;
  Duration get recordingDuration => _recordingDuration;
  String? get currentPlayingPath => _currentPlayingPath;
  Duration get playbackPosition => _playbackPosition;
  Duration get totalDuration => _totalDuration;

  /// Initialize the audio service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing audio service');

      // Check if recording is supported
      final isSupported = await _recorder.hasPermission();
      if (!isSupported) {
        AppLogger.warn('Audio recording not supported or permission denied');
      }

      // Initialize audio player listeners
      _setupPlayerListeners();

      AppLogger.info('Audio service initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize audio service', e, stackTrace);
      throw AudioServiceException('Failed to initialize audio service: $e');
    }
  }

  /// Set up audio player listeners
  void _setupPlayerListeners() {
    // Listen to player state changes
    _player.onPlayerStateChanged.listen((PlayerState state) {
      final wasPlaying = _isPlaying;
      _isPlaying = state == PlayerState.playing;

      if (wasPlaying != _isPlaying) {
        notifyListeners();
      }
    });

    // Listen to position changes
    _player.onPositionChanged.listen((Duration position) {
      _playbackPosition = position;
      notifyListeners();
    });

    // Listen to duration changes
    _player.onDurationChanged.listen((Duration duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    // Listen to player completion
    _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _playbackPosition = Duration.zero;
      _currentPlayingPath = null;
      notifyListeners();
    });
  }

  /// Request audio recording permission
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        AppLogger.info('Microphone permission granted');
        return true;
      } else if (status.isPermanentlyDenied) {
        AppLogger.warn('Microphone permission permanently denied');
        return false;
      } else {
        AppLogger.warn('Microphone permission denied');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to request microphone permission', e, stackTrace);
      return false;
    }
  }

  /// Start audio recording
  Future<String?> startRecording({String? customPath}) async {
    try {
      AppLogger.info('Starting audio recording');

      // Check permission first
      if (!await _recorder.hasPermission()) {
        final hasPermission = await requestPermission();
        if (!hasPermission) {
          throw AudioServiceException('Microphone permission denied');
        }
      }

      // Generate file path
      final String recordingPath = customPath ?? await _generateRecordingPath();

      // Start recording with high quality settings
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc, // High quality AAC encoding
          bitRate: 128000, // 128kbps
          sampleRate: 44100, // CD quality
        ),
        path: recordingPath,
      );

      _isRecording = true;
      _currentRecordingPath = recordingPath;
      _recordingDuration = Duration.zero;

      // Start duration tracking
      _startDurationTracking();

      notifyListeners();
      AppLogger.info('Audio recording started: $recordingPath');

      return recordingPath;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to start recording', e, stackTrace);
      throw AudioServiceException('Failed to start recording: $e');
    }
  }

  /// Stop audio recording
  Future<String?> stopRecording() async {
    try {
      AppLogger.info('Stopping audio recording');

      if (!_isRecording) {
        AppLogger.warn('Not currently recording');
        return null;
      }

      final path = await _recorder.stop();

      _isRecording = false;
      final recordedPath = _currentRecordingPath;
      _currentRecordingPath = null;

      notifyListeners();
      AppLogger.info('Audio recording stopped: $path');

      // Return the actual path from recorder.stop(), fallback to cached path
      return path ?? recordedPath;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to stop recording', e, stackTrace);
      throw AudioServiceException('Failed to stop recording: $e');
    }
  }

  /// Pause audio recording
  Future<void> pauseRecording() async {
    try {
      AppLogger.info('Pausing audio recording');

      if (!_isRecording) {
        AppLogger.warn('Not currently recording');
        return;
      }

      await _recorder.pause();
      _isPaused = true;

      notifyListeners();
      AppLogger.info('Audio recording paused');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to pause recording', e, stackTrace);
      throw AudioServiceException('Failed to pause recording: $e');
    }
  }

  /// Resume audio recording
  Future<void> resumeRecording() async {
    try {
      AppLogger.info('Resuming audio recording');

      if (!_isRecording || !_isPaused) {
        AppLogger.warn('Not currently paused');
        return;
      }

      await _recorder.resume();
      _isPaused = false;

      notifyListeners();
      AppLogger.info('Audio recording resumed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to resume recording', e, stackTrace);
      throw AudioServiceException('Failed to resume recording: $e');
    }
  }

  /// Get audio amplitude (for waveform visualization)
  Future<double> getAmplitude() async {
    try {
      if (!_isRecording) {
        return 0.0;
      }

      final amplitude = await _recorder.getAmplitude();

      // 使用 current 值进行音频振幅映射
      final currentDb = amplitude.current;

      // 静音阈值：低于-50dB视为静音
      if (currentDb <= -50.0) {
        return 0.0;
      }

      // 使用更敏感的dB范围映射：-50dB 到 -10dB 为主要工作区间
      // -50dB (静音) → 0.0, -10dB (响亮) → 1.0
      double normalizedDb;
      if (currentDb >= -10.0) {
        // 非常响亮的声音，映射到 0.8-1.0
        normalizedDb = 0.8 + (currentDb + 10.0) / 10.0 * 0.2;
      } else {
        // 正常音量范围，映射到 0.0-0.8
        normalizedDb = (currentDb + 50.0) / 40.0 * 0.8;
      }

      // 应用平方根映射增强低音量的可见性
      final enhancedAmplitude = math.sqrt(normalizedDb.clamp(0.0, 1.0));

      // 只在调试模式下记录详细信息
      if (kDebugMode && enhancedAmplitude > 0.1) {
        AppLogger.debug(
          'Audio: ${currentDb.toStringAsFixed(1)}dB → ${(enhancedAmplitude * 100).toStringAsFixed(0)}%',
        );
      }

      return enhancedAmplitude;
    } catch (e) {
      AppLogger.debug('Failed to get recording amplitude: $e');
      return 0.0; // 异常时返回静音
    }
  }

  /// Delete an audio file
  Future<bool> deleteAudioFile(String filePath) async {
    try {
      AppLogger.info('Deleting audio file: $filePath');

      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('Audio file deleted successfully');
        return true;
      } else {
        AppLogger.warn('Audio file does not exist: $filePath');
        return false;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete audio file', e, stackTrace);
      return false;
    }
  }

  /// Get audio file size in bytes
  Future<int> getAudioFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      AppLogger.debug('Failed to get audio file size: $e');
      return 0;
    }
  }

  /// Get audio file duration using audioplayers
  Future<Duration> getAudioDuration(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        AppLogger.debug('Audio file does not exist: $filePath');
        return Duration.zero;
      }

      // Check file size to ensure it's not empty
      final fileSize = await file.length();
      if (fileSize == 0) {
        AppLogger.debug('Audio file is empty: $filePath');
        return Duration.zero;
      }

      // Create a temporary player to get duration
      final tempPlayer = AudioPlayer();
      Duration? duration;

      try {
        // Set source and wait for it to be ready
        await tempPlayer.setSourceDeviceFile(filePath);

        // Listen for duration changes
        final completer = Completer<Duration>();
        late StreamSubscription<Duration> subscription;

        subscription = tempPlayer.onDurationChanged.listen((Duration d) {
          if (!completer.isCompleted && d.inMilliseconds > 0) {
            completer.complete(d);
          }
          subscription.cancel();
        });

        // Also try to get duration directly
        try {
          final directDuration = await tempPlayer.getDuration();
          if (directDuration != null && directDuration.inMilliseconds > 0) {
            subscription.cancel();
            await tempPlayer.dispose();
            AppLogger.debug(
              'Got direct duration: $directDuration for $filePath',
            );
            return directDuration;
          }
        } catch (e) {
          AppLogger.debug('Failed to get direct duration: $e');
        }

        // Wait for duration with timeout
        duration = await completer.future.timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            subscription.cancel();
            AppLogger.debug('Timeout getting audio duration for $filePath');
            return Duration.zero;
          },
        );

        await tempPlayer.dispose();
        AppLogger.debug('Got stream duration: $duration for $filePath');
        return duration;
      } catch (e) {
        await tempPlayer.dispose();
        AppLogger.debug('Failed to get audio duration with audioplayers: $e');
        return Duration.zero;
      }
    } catch (e) {
      AppLogger.debug('Failed to get audio duration: $e');
      return Duration.zero;
    }
  }

  /// Play audio file
  Future<void> playAudio(String filePath) async {
    try {
      AppLogger.info('Playing audio file: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        throw AudioServiceException('Audio file not found: $filePath');
      }

      // Stop current playback if any
      if (_isPlaying) {
        await stopAudio();
      }

      // Set the audio source and play
      await _player.setSourceDeviceFile(filePath);
      await _player.resume();

      _currentPlayingPath = filePath;
      notifyListeners();

      AppLogger.info('Audio playback started');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to play audio', e, stackTrace);
      throw AudioServiceException('Failed to play audio: $e');
    }
  }

  /// Pause audio playback
  Future<void> pauseAudio() async {
    try {
      if (_player.state == PlayerState.playing) {
        await _player.pause();
        AppLogger.info('Audio playback paused');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to pause audio', e, stackTrace);
      throw AudioServiceException('Failed to pause audio: $e');
    }
  }

  /// Resume audio playback
  Future<void> resumeAudio() async {
    try {
      if (_player.state == PlayerState.paused) {
        await _player.resume();
        AppLogger.info('Audio playback resumed');
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to resume audio', e, stackTrace);
      throw AudioServiceException('Failed to resume audio: $e');
    }
  }

  /// Stop audio playback
  Future<void> stopAudio() async {
    try {
      await _player.stop();
      _currentPlayingPath = null;
      _playbackPosition = Duration.zero;
      notifyListeners();
      AppLogger.info('Audio playback stopped');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to stop audio', e, stackTrace);
      throw AudioServiceException('Failed to stop audio: $e');
    }
  }

  /// Seek to specific position in audio
  Future<void> seekTo(Duration position) async {
    try {
      await _player.seek(position);
      AppLogger.debug('Seeked to position: $position');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to seek audio', e, stackTrace);
      throw AudioServiceException('Failed to seek audio: $e');
    }
  }

  /// Generate a unique recording path
  Future<String> _generateRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');

    // Create recordings directory if it doesn't exist
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${recordingsDir.path}/recording_$timestamp.aac';
  }

  /// Start tracking recording duration
  void _startDurationTracking() {
    // This would typically use a timer to update the duration
    // For now, it's a placeholder for the tracking logic
    // You could implement a periodic timer here to update _recordingDuration
  }

  /// Clean up resources
  @override
  Future<void> dispose() async {
    try {
      AppLogger.info('Disposing audio service');

      if (_isRecording) {
        await stopRecording();
      }

      if (_isPlaying) {
        await stopAudio();
      }

      await _recorder.dispose();
      await _player.dispose();
      super.dispose();

      AppLogger.info('Audio service disposed');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to dispose audio service', e, stackTrace);
    }
  }
}

/// Custom exception for audio service errors
class AudioServiceException implements Exception {
  final String message;

  const AudioServiceException(this.message);

  @override
  String toString() => 'AudioServiceException: $message';
}
