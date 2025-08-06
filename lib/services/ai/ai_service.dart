import 'dart:async';
import 'package:diaryx/utils/app_logger.dart';
import 'configs/ai_config_service.dart';
import 'ai_engine.dart' as ai_engine;
import 'models/cancellation_token.dart';
import 'models/config_models.dart';
import 'models/ai_models.dart';
import 'models/chat_models.dart';
import '../../models/moment.dart';

/// Simplified AI service focused on AI operations only
class AIService {
  static AIService? _instance;

  AIConfigService? _configService;
  bool _isConfigInitialized = false;
  Completer<void>? _configInitCompleter;

  // Private constructor
  AIService._();

  /// Singleton access
  static AIService get instance {
    _instance ??= AIService._();
    return _instance!;
  }

  /// Get the AI config service (for configuration management)
  AIConfigService? get configService => _configService;

  /// Initialize the AI configuration service (config only, not engine)
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing AI service (config only)');

      _configService = AIConfigService();
      await _configService!
          .initialize(); // Only reads config, doesn't create engine
      _isConfigInitialized = true;

      AppLogger.info('AI service config initialized successfully');

      // Complete the initialization if there's a waiting completer
      _configInitCompleter?.complete();
    } catch (e) {
      AppLogger.error('Failed to initialize AI service config', e);
      // Complete with error if initialization fails
      _configInitCompleter?.completeError(e);
      rethrow;
    }
  }

  /// Ensure AI config service is initialized (lazy loading)
  Future<void> _ensureConfigInitialized() async {
    if (_isConfigInitialized) return;

    // If already initializing, wait for the existing initialization
    if (_configInitCompleter != null) {
      return _configInitCompleter!.future;
    }

    // Start initialization
    _configInitCompleter = Completer<void>();

    try {
      await initialize();
    } catch (e) {
      _configInitCompleter =
          null; // Reset completer on error so it can be retried
      rethrow;
    }
  }

  /// Get the current AI engine (with lazy initialization)
  Future<ai_engine.AIEngine?> get currentEngine async {
    await _ensureConfigInitialized();
    return await _configService?.getCurrentService();
  }

  /// Check if AI engine is available
  Future<bool> get isAvailable async {
    final engine = await currentEngine;
    if (engine == null) return false;
    return await engine.isAvailable();
  }

  /// Get AI engine configuration
  Future<AIEngineConfig?> get config async {
    final engine = await currentEngine;
    return engine?.getConfig();
  }

  // ========== Real-time AI Operations ==========

  /// Enhance text with streaming output
  Stream<String> enhanceText(
    String text,
    CancellationToken cancellationToken,
  ) async* {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return;
    }

    try {
      await for (final chunk in engine.enhanceText(
        text,
        cancellationToken: cancellationToken,
      )) {
        yield chunk;
      }
    } catch (e) {
      AppLogger.error('Failed to enhance text', e);
      rethrow;
    }
  }

  /// Analyze mood with cancellation support
  Future<MoodAnalysis?> analyzeMood(
    String text,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.analyzeMood(
        text,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      AppLogger.error('Failed to analyze mood', e);
      return null;
    }
  }

  /// Generate tags with cancellation support
  Future<List<String>?> generateTags(
    String content,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.generateTags(
        content,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      AppLogger.error('Failed to generate tags', e);
      return null;
    }
  }

  /// Chat with moment context
  Stream<String> chat(
    List<ChatMessage> messages,
    List<Moment> moments,
    CancellationToken cancellationToken,
  ) async* {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return;
    }

    try {
      await for (final chunk in engine.chat(
        messages,
        moments,
        cancellationToken: cancellationToken,
      )) {
        yield chunk;
      }
    } catch (e) {
      AppLogger.error('Failed to chat', e);
      rethrow;
    }
  }

  /// Transcribe audio
  Future<String?> transcribeAudio(
    String audioPath,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.transcribeAudio(
        audioPath,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Audio transcription was cancelled');
        return null;
      }
      AppLogger.error('Failed to transcribe audio', e);
      return null;
    }
  }

  /// Analyze image content
  Future<String?> analyzeImage(
    String imagePath,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.analyzeImage(
        imagePath,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Image analysis was cancelled');
        return null;
      }
      AppLogger.error('Failed to analyze image', e);
      return null;
    }
  }

  /// Summarize text content
  Future<String?> summarizeText(
    String text,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.summarizeText(
        text,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Text summarization was cancelled');
        return null;
      }
      AppLogger.error('Failed to summarize text', e);
      return null;
    }
  }

  /// Expand text with streaming output
  Stream<String> expandText(
    String text,
    CancellationToken cancellationToken,
  ) async* {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return;
    }

    try {
      await for (final chunk in engine.expandText(
        text,
        cancellationToken: cancellationToken,
      )) {
        yield chunk;
      }
    } catch (e) {
      AppLogger.error('Failed to expand text', e);
      rethrow;
    }
  }

  /// Generate embedding
  Future<List<double>?> generateEmbedding(
    String text,
    CancellationToken cancellationToken,
  ) async {
    final engine = await currentEngine;
    if (engine == null) {
      AppLogger.warn('AI engine not available');
      return null;
    }

    try {
      return await engine.generateEmbedding(
        text,
        cancellationToken: cancellationToken,
      );
    } catch (e) {
      if (e is OperationCancelledException) {
        AppLogger.info('Embedding generation was cancelled');
        return null;
      }
      AppLogger.error('Failed to generate embedding', e);
      return null;
    }
  }

  // ========== Service Management ==========

  /// Switch to a different AI engine
  Future<void> switchEngine(AIServiceType engineType) async {
    await _ensureConfigInitialized();
    try {
      AppLogger.info('Switching AI engine to: $engineType');

      // Get default configuration for the selected engine type
      final newConfig = AIConfigExtension.defaultFor(engineType);

      // Update the configuration, which will create and initialize the new engine
      final success = await _configService?.updateConfig(newConfig) ?? false;

      if (success) {
        AppLogger.info('Successfully switched to AI engine: $engineType');
      } else {
        throw Exception('Failed to update AI engine configuration');
      }
    } catch (e) {
      AppLogger.error('Failed to switch AI engine', e);
      rethrow;
    }
  }

  /// Dispose the AI service
  Future<void> dispose() async {
    try {
      AppLogger.info('Disposing AI service');

      await _configService?.dispose();
      _configService = null;

      AppLogger.info('AI service disposed');
    } catch (e) {
      AppLogger.error('Error disposing AI service', e);
    }
  }
}
