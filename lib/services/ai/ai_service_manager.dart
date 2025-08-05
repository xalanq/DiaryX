import 'package:diaryx/utils/app_logger.dart';
import 'configs/ai_config_service.dart';
import 'ai_service.dart';
import 'models/cancellation_token.dart';
import 'models/config_models.dart';
import 'models/ai_models.dart';
import 'models/chat_models.dart';
import '../../models/moment.dart';

/// Simplified AI service manager focused on AI operations only
class AIServiceManager {
  static AIServiceManager? _instance;

  AIConfigService? _configService;

  // Private constructor
  AIServiceManager._();

  /// Singleton access
  static AIServiceManager get instance {
    _instance ??= AIServiceManager._();
    return _instance!;
  }

  /// Initialize the AI service manager
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing AI service manager');

      _configService = AIConfigService();
      await _configService!.initialize();

      AppLogger.info('AI service manager initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AI service manager', e);
      rethrow;
    }
  }

  /// Get the current AI service
  AIService? get currentService => _configService?.currentService;

  /// Check if AI service is available
  Future<bool> get isAvailable async {
    final service = currentService;
    if (service == null) return false;
    return await service.isAvailable();
  }

  /// Get AI service configuration
  AIServiceConfig? get config => currentService?.getConfig();

  // ========== Real-time AI Operations ==========

  /// Enhance text with streaming output
  Stream<String> enhanceText(
    String text,
    CancellationToken cancellationToken,
  ) async* {
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return;
    }

    try {
      await for (final chunk in service.enhanceText(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.analyzeMood(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.generateTags(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return;
    }

    try {
      await for (final chunk in service.chat(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.transcribeAudio(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.analyzeImage(
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
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.summarizeText(
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

  /// Generate embedding
  Future<List<double>?> generateEmbedding(
    String text,
    CancellationToken cancellationToken,
  ) async {
    final service = currentService;
    if (service == null) {
      AppLogger.warn('AI service not available');
      return null;
    }

    try {
      return await service.generateEmbedding(
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

  /// Switch to a different AI service
  Future<void> switchService(AIServiceType serviceType) async {
    try {
      final currentConfig = _configService?.config ?? const AIConfig();
      final newConfig = currentConfig.copyWith(serviceType: serviceType);
      await _configService?.updateConfig(newConfig);
      AppLogger.info('Switched to AI service: $serviceType');
    } catch (e) {
      AppLogger.error('Failed to switch AI service', e);
      rethrow;
    }
  }

  /// Dispose the AI service manager
  Future<void> dispose() async {
    try {
      AppLogger.info('Disposing AI service manager');

      await _configService?.dispose();
      _configService = null;

      AppLogger.info('AI service manager disposed');
    } catch (e) {
      AppLogger.error('Error disposing AI service manager', e);
    }
  }
}
