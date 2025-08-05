import 'package:flutter/foundation.dart';

/// Environment configuration for DiaryX
class EnvConfig {
  /// Private constructor to prevent instantiation
  EnvConfig._();

  static const String version = '1.0.0';

  // Database configuration
  static const String databaseName = 'diaryx.db';
  static const int databaseVersion = 3;

  // Vector database configuration
  static const String vectorDbName = 'diaryx_vectors';
  static const int embeddingDimension = 768;

  // File storage configuration
  static const String mediaFolderName = 'media';
  static const String audioFolderName = 'audio';
  static const String imageFolderName = 'images';
  static const String videoFolderName = 'videos';
  static const String thumbnailsFolderName = 'thumbnails';

  // Text content configuration
  static const int timelineMaxLinesCollapsed = 10;
  static const int timelineMaxCharactersCollapsed = 1000;

  // Image grid configuration
  static const int timelineCollapsedDisplayImages = 9;

  // Audio recording configuration
  static const int audioSampleRate = 44100;
  static const int audioBitRate = 128000;
  static const String audioFormat = 'aac';
  static const Duration maxTranscriptionDuration = Duration(minutes: 3);

  // Image/video configuration
  static const int imageQuality = 85;
  static const int thumbnailSize = 200;
  static const int maxVideoLength = 300; // 5 minutes in seconds

  // AI processing configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const int processingQueueSize = 10;

  // AI task processing thresholds
  static const Duration minAudioDurationForDetailedTranscription = Duration(
    seconds: 10,
  );
  static const int minContentLengthForSummary = 100; // characters
  static const int maxConcurrentAITasks = 3;

  // Real-time AI operations timeouts
  static const Duration textEnhancementTimeout = Duration(minutes: 2);
  static const Duration moodAnalysisTimeout = Duration(seconds: 30);
  static const Duration chatCompletionTimeout = Duration(minutes: 5);

  // Background task processing
  static const int maxBackgroundTasksPerMoment = 10;

  // Task deduplication
  static const bool enableTaskDeduplication = true;
  static const Duration taskResultCacheExpiry = Duration(hours: 1);

  // Task queue configuration
  static const int maxTaskRetries = 3;
  static const Duration taskRetryDelay = Duration(seconds: 5);
  static const Duration taskTimeout = Duration(minutes: 10);
  static const int maxConcurrentTasks = 3;
  static const Duration taskCleanupInterval = Duration(hours: 6);
  static const Duration completedTaskRetention = Duration(days: 3);

  // Task priorities
  static const int highPriority = 1;
  static const int normalPriority = 2;
  static const int lowPriority = 3;

  // Streaming configuration
  static const Duration streamingChunkDelay = Duration(milliseconds: 100);
  static const int maxStreamingChunkSize = 50; // characters per chunk

  // Search configuration
  static const int defaultSearchLimit = 20;
  static const double similarityThreshold = 0.7;

  // Authentication configuration
  static const int minPasswordLength = 4;
  static const int maxPasswordLength = 6;
  static const int maxLoginAttempts = 5;
  static const Duration loginCooldownDuration = Duration(minutes: 5);

  // App configuration
  static const String appName = 'DiaryX';
  static const bool isDebugMode =
      kDebugMode; // Will be set based on build configuration

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
