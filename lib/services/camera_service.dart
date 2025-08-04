import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../utils/app_logger.dart';

/// Service for camera operations and media processing
class CameraService {
  static CameraService? _instance;
  static CameraService get instance {
    _instance ??= CameraService._();
    return _instance!;
  }

  CameraService._();

  final ImagePicker _picker = ImagePicker();
  List<CameraDescription>? _cameras;
  CameraController? _controller;

  /// Initialize available cameras
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      AppLogger.info('Available cameras: ${_cameras?.length ?? 0}');
    } catch (e) {
      AppLogger.error('Failed to initialize cameras', e);
    }
  }

  /// Get available cameras
  List<CameraDescription>? get cameras => _cameras;

  /// Initialize camera controller
  Future<CameraController?> initializeCamera({
    CameraLensDirection direction = CameraLensDirection.back,
    ResolutionPreset resolution = ResolutionPreset.high,
  }) async {
    if (_cameras == null || _cameras!.isEmpty) {
      AppLogger.error('No cameras available');
      return null;
    }

    try {
      // Find camera with specified direction
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == direction,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(camera, resolution);
      await _controller!.initialize();

      AppLogger.info('Camera initialized: ${camera.name}');
      return _controller;
    } catch (e) {
      AppLogger.error('Failed to initialize camera controller', e);
      return null;
    }
  }

  /// Dispose camera controller
  Future<void> disposeCamera() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Take a photo with the camera
  Future<String?> takePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      AppLogger.error('Camera not initialized');
      return null;
    }

    try {
      final XFile photo = await _controller!.takePicture();

      // Save to app directory
      final String savedPath = await _saveMediaFile(
        photo.path,
        'photos',
        'jpg',
      );

      // Compress image
      await _compressImage(savedPath);

      AppLogger.info('Photo captured and saved: $savedPath');
      return savedPath;
    } catch (e) {
      AppLogger.error('Failed to take photo', e);
      return null;
    }
  }

  /// Start video recording
  Future<void> startVideoRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      AppLogger.error('Camera not initialized');
      return;
    }

    if (_controller!.value.isRecordingVideo) {
      AppLogger.warn('Already recording video');
      return;
    }

    try {
      await _controller!.startVideoRecording();
      AppLogger.info('Video recording started');
    } catch (e) {
      AppLogger.error('Failed to start video recording', e);
    }
  }

  /// Stop video recording
  Future<String?> stopVideoRecording() async {
    if (_controller == null || !_controller!.value.isRecordingVideo) {
      AppLogger.error('Not recording video');
      return null;
    }

    try {
      final XFile video = await _controller!.stopVideoRecording();

      // Save to app directory
      final String savedPath = await _saveMediaFile(
        video.path,
        'videos',
        'mp4',
      );

      AppLogger.info('Video recorded and saved: $savedPath');
      return savedPath;
    } catch (e) {
      AppLogger.error('Failed to stop video recording', e);
      return null;
    }
  }

  /// Pick image from gallery
  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      if (image == null) return null;

      // Save to app directory
      final String savedPath = await _saveMediaFile(
        image.path,
        'photos',
        p.extension(image.path).substring(1),
      );

      // Compress image
      await _compressImage(savedPath);

      AppLogger.info('Image picked from gallery: $savedPath');
      return savedPath;
    } catch (e) {
      AppLogger.error('Failed to pick image from gallery', e);
      return null;
    }
  }

  /// Pick video from gallery
  Future<String?> pickVideoFromGallery() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5), // 5 minute limit
      );

      if (video == null) return null;

      // Save to app directory
      final String savedPath = await _saveMediaFile(
        video.path,
        'videos',
        p.extension(video.path).substring(1),
      );

      AppLogger.info('Video picked from gallery: $savedPath');
      return savedPath;
    } catch (e) {
      AppLogger.error('Failed to pick video from gallery', e);
      return null;
    }
  }

  /// Pick multiple images from gallery
  Future<List<String>> pickMultipleImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );

      final List<String> savedPaths = [];

      for (final image in images) {
        final String savedPath = await _saveMediaFile(
          image.path,
          'photos',
          p.extension(image.path).substring(1),
        );

        // Compress image
        await _compressImage(savedPath);
        savedPaths.add(savedPath);
      }

      AppLogger.info('${savedPaths.length} images picked from gallery');
      return savedPaths;
    } catch (e) {
      AppLogger.error('Failed to pick multiple images from gallery', e);
      return [];
    }
  }

  /// Save media file to app directory
  Future<String> _saveMediaFile(
    String sourcePath,
    String subfolder,
    String extension,
  ) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory mediaDir = Directory(
      p.join(appDir.path, 'media', subfolder),
    );

    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}.$extension';
    final String destPath = p.join(mediaDir.path, fileName);

    final File sourceFile = File(sourcePath);
    await sourceFile.copy(destPath);

    return destPath;
  }

  /// Compress image while preserving original
  Future<void> _compressImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      final Uint8List bytes = await imageFile.readAsBytes();

      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return;

      // Resize if too large (max 1920x1920)
      if (image.width > 1920 || image.height > 1920) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? 1920 : null,
          height: image.height > image.width ? 1920 : null,
        );
      }

      // Compress and save
      final Uint8List compressedBytes = Uint8List.fromList(
        img.encodeJpg(image, quality: 85),
      );

      await imageFile.writeAsBytes(compressedBytes);

      AppLogger.info('Image compressed: $imagePath');
    } catch (e) {
      AppLogger.error('Failed to compress image: $imagePath', e);
    }
  }

  /// Generate thumbnail for video
  Future<String?> generateVideoThumbnail(String videoPath) async {
    try {
      // For now, return a placeholder
      // In a real implementation, you'd use video_thumbnail package
      AppLogger.info('Video thumbnail generation requested: $videoPath');
      return null;
    } catch (e) {
      AppLogger.error('Failed to generate video thumbnail', e);
      return null;
    }
  }

  /// Get media file size
  Future<int> getFileSize(String filePath) async {
    try {
      final File file = File(filePath);
      return await file.length();
    } catch (e) {
      AppLogger.error('Failed to get file size: $filePath', e);
      return 0;
    }
  }

  /// Delete media file
  Future<bool> deleteMediaFile(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('Media file deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Failed to delete media file: $filePath', e);
      return false;
    }
  }

  /// Check if camera permission is granted
  Future<bool> checkCameraPermission() async {
    // This would typically use permission_handler package
    // For now, assume permission is granted
    return true;
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    // This would typically use permission_handler package
    // For now, assume permission is granted
    return true;
  }
}
