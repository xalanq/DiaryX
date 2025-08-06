import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../consts/env_config.dart';
import 'app_logger.dart';

/// File utility functions for DiaryX
class FileHelper {
  /// Private constructor to prevent instantiation
  FileHelper._();

  /// Get application documents directory
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get media storage directory
  static Future<Directory> getMediaDirectory() async {
    final appDir = await getAppDocumentsDirectory();
    final mediaDir = Directory(
      path.join(appDir.path, EnvConfig.mediaFolderName),
    );
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  /// Get audio storage directory
  static Future<Directory> getAudioDirectory() async {
    final mediaDir = await getMediaDirectory();
    final audioDir = Directory(
      path.join(mediaDir.path, EnvConfig.audioFolderName),
    );
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    return audioDir;
  }

  /// Get images storage directory
  static Future<Directory> getImagesDirectory() async {
    final mediaDir = await getMediaDirectory();
    final imagesDir = Directory(
      path.join(mediaDir.path, EnvConfig.imageFolderName),
    );
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  /// Get videos storage directory
  static Future<Directory> getVideosDirectory() async {
    final mediaDir = await getMediaDirectory();
    final videosDir = Directory(
      path.join(mediaDir.path, EnvConfig.videoFolderName),
    );
    if (!await videosDir.exists()) {
      await videosDir.create(recursive: true);
    }
    return videosDir;
  }

  /// Get thumbnails storage directory
  static Future<Directory> getThumbnailsDirectory() async {
    final mediaDir = await getMediaDirectory();
    final thumbnailsDir = Directory(
      path.join(mediaDir.path, EnvConfig.thumbnailsFolderName),
    );
    if (!await thumbnailsDir.exists()) {
      await thumbnailsDir.create(recursive: true);
    }
    return thumbnailsDir;
  }

  /// Generate unique filename with timestamp
  static String generateUniqueFilename(String extension) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$timestamp$extension';
  }

  /// Get file extension from filename
  static String getFileExtension(String filename) {
    return path.extension(filename).toLowerCase();
  }

  /// Get file size in bytes
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  /// Format file size to human readable string
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// Delete file if exists
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Copy file to new location
  static Future<bool> copyFile(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      final sourceFile = File(sourcePath);
      AppLogger.info('Copying file from: $sourcePath');
      AppLogger.info('Destination: $destinationPath');

      if (await sourceFile.exists()) {
        AppLogger.info('Source file exists, copying...');
        await sourceFile.copy(destinationPath);

        // Verify the copy was successful
        final destinationFile = File(destinationPath);
        if (await destinationFile.exists()) {
          AppLogger.info('File copied successfully');
          return true;
        } else {
          AppLogger.error('Copy failed - destination file does not exist');
          return false;
        }
      } else {
        AppLogger.error('Source file does not exist');
        return false;
      }
    } catch (e) {
      AppLogger.error('Error copying file: $e');
      return false;
    }
  }

  /// Move file to new location
  static Future<bool> moveFile(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        await sourceFile.rename(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get MIME type from file extension
  static String getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      // Images
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';

      // Videos
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';
      case '.webm':
        return 'video/webm';

      // Audio
      case '.mp3':
        return 'audio/mpeg';
      case '.aac':
        return 'audio/aac';
      case '.wav':
        return 'audio/wav';
      case '.m4a':
        return 'audio/mp4';

      default:
        return 'application/octet-stream';
    }
  }

  /// Check if extension is image
  static bool isImage(String extension) {
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  /// Check if extension is video
  static bool isVideo(String extension) {
    const videoExtensions = ['.mp4', '.mov', '.avi', '.webm'];
    return videoExtensions.contains(extension.toLowerCase());
  }

  /// Check if extension is audio
  static bool isAudio(String extension) {
    const audioExtensions = ['.mp3', '.aac', '.wav', '.m4a'];
    return audioExtensions.contains(extension.toLowerCase());
  }

  /// Convert absolute path to relative path for database storage
  /// This solves iOS issue where app sandbox paths change on each launch
  static Future<String> toRelativePath(String absolutePath) async {
    try {
      final appDir = await getAppDocumentsDirectory();
      final appDirPath = appDir.path;

      if (absolutePath.startsWith(appDirPath)) {
        // Remove the app directory prefix to get relative path
        final relativePath = absolutePath.substring(appDirPath.length);
        // Remove leading slash if present
        return relativePath.startsWith('/')
            ? relativePath.substring(1)
            : relativePath;
      } else {
        // If not in app directory, return as is (shouldn't happen in normal cases)
        return absolutePath;
      }
    } catch (e) {
      // Fallback: return original path if conversion fails
      return absolutePath;
    }
  }

  /// Convert relative path to absolute path for file access
  /// This rebuilds the full path using current app sandbox location
  static Future<String> toAbsolutePath(String relativePath) async {
    try {
      final appDir = await getAppDocumentsDirectory();
      final absolutePath = path.join(appDir.path, relativePath);
      AppLogger.info('Converting relative path: $relativePath');
      AppLogger.info('App directory: ${appDir.path}');
      AppLogger.info('Absolute path: $absolutePath');
      return absolutePath;
    } catch (e) {
      AppLogger.error('Error converting to absolute path: $e');
      // Fallback: return original path if conversion fails
      return relativePath;
    }
  }

  /// Check if a path is already relative (not absolute)
  static bool isRelativePath(String filePath) {
    return !path.isAbsolute(filePath);
  }

  /// Batch convert multiple absolute paths to relative paths
  static Future<List<String>> toRelativePathsBatch(
    List<String> absolutePaths,
  ) async {
    final results = <String>[];
    for (final absolutePath in absolutePaths) {
      final relativePath = await toRelativePath(absolutePath);
      results.add(relativePath);
    }
    return results;
  }

  /// Batch convert multiple relative paths to absolute paths
  static Future<List<String>> toAbsolutePathsBatch(
    List<String> relativePaths,
  ) async {
    final results = <String>[];
    for (final relativePath in relativePaths) {
      final absolutePath = await toAbsolutePath(relativePath);
      results.add(absolutePath);
    }
    return results;
  }
}
