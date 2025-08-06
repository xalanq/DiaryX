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

  // Private constructor
  AIService._();

  /// Singleton access
  static AIService get instance {
    _instance ??= AIService._();
    return _instance!;
  }

  /// Initialize the AI service manager
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing AI service');

      _configService = AIConfigService();
      await _configService!.initialize();

      AppLogger.info('AI service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AI service', e);
      rethrow;
    }
  }

  /// Get the current AI service
  ai_engine.AIEngine? get currentEngine => _configService?.currentService;

  /// Check if AI engine is available
  Future<bool> get isAvailable async {
    final engine = currentEngine;
    if (engine == null) return false;
    return await engine.isAvailable();
  }

  /// Get AI engine configuration
  AIEngineConfig? get config => currentEngine?.getConfig();

  // ========== Real-time AI Operations ==========

  /// Enhance text with streaming output
  Stream<String> enhanceText(
    String text,
    CancellationToken cancellationToken,
  ) async* {
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    final engine = currentEngine;
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
    try {
      final currentConfig = _configService?.config ?? const AIConfig();
      final newConfig = currentConfig.copyWith(serviceType: engineType);
      await _configService?.updateConfig(newConfig);
      AppLogger.info('Switched to AI engine: $engineType');
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
