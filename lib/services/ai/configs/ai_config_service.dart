import 'dart:convert';
import 'package:diaryx/utils/app_logger.dart';
import 'package:diaryx/databases/app_database.dart';
import '../ai_engine.dart' as ai_engine;
import '../implementations/ai_service_impl.dart';
import '../implementations/mock_ai_engine.dart';
import '../implementations/ollama_service.dart';
import '../implementations/mediapipe_llm_engine.dart';
import '../models/config_models.dart';

/// Service for managing AI configuration and creating AI service instances
class AIConfigService {
  static const String _configKey = 'ai_config';

  final AppDatabase _database = AppDatabase.instance;
  AIConfig _currentConfig = const AIConfig();
  ai_engine.AIEngine? _currentService;

  /// Get current AI configuration
  AIConfig get config => _currentConfig;

  /// Get current AI engine instance
  ai_engine.AIEngine? get currentService => _currentService;

  /// Initialize with stored configuration or defaults
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing AI configuration service');

      final storedConfigJson = await _database.getValue(_configKey);
      if (storedConfigJson != null) {
        final configData = jsonDecode(storedConfigJson);
        _currentConfig = AIConfig.fromJson(configData);
        AppLogger.info(
          'Loaded stored AI config: ${_currentConfig.serviceType.name}',
        );
      } else {
        // Use default mock configuration for first run
        _currentConfig = AIConfigExtension.defaultFor(AIServiceType.mock);
        await _saveConfig();
        AppLogger.info(
          'Using default AI config: ${_currentConfig.serviceType.name}',
        );
      }

      // Create service instance
      await _createServiceInstance();

      // Initialize the service
      if (_currentService != null) {
        await _currentService!.initialize();
        AppLogger.info('Initial AI engine initialized successfully');
      }

      AppLogger.info('AI configuration service initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AI configuration service', e);
      // Fall back to mock engine
      _currentConfig = const AIConfig();
      _currentService = MockAIEngine();

      // Initialize the fallback mock engine
      try {
        await _currentService!.initialize();
        AppLogger.info('Fallback mock engine initialized');
      } catch (e) {
        AppLogger.error('Failed to initialize fallback mock engine', e);
      }
    }
  }

  /// Update AI configuration
  Future<bool> updateConfig(AIConfig newConfig) async {
    try {
      AppLogger.info('Updating AI config to: ${newConfig.serviceType.name}');

      if (!newConfig.isValid) {
        AppLogger.warn('Invalid AI configuration provided');
        return false;
      }

      _currentConfig = newConfig;
      await _saveConfig();

      // Dispose old service if exists
      if (_currentService != null) {
        await _disposeCurrentService();
      }

      // Create new service instance
      await _createServiceInstance();

      // Initialize the new service
      if (_currentService != null) {
        await _currentService!.initialize();
        AppLogger.info('New AI engine initialized successfully');
      }

      AppLogger.info('AI configuration updated successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to update AI configuration', e);
      return false;
    }
  }

  /// Test if a configuration works
  Future<bool> testConfig(AIConfig config) async {
    try {
      AppLogger.info('Testing AI config: ${config.serviceType.name}');

      if (!config.isValid) {
        return false;
      }

      // Create temporary engine instance
      final tempService = await _createEngine(config);
      if (tempService == null) {
        return false;
      }

      // Test availability
      final isAvailable = await tempService.isAvailable();

      // Dispose temporary engine
      if (tempService is AIEngineImpl) {
        // For now, we don't have a dispose method, but we could add one
      }

      AppLogger.info('AI config test result: $isAvailable');
      return isAvailable;
    } catch (e) {
      AppLogger.warn('AI config test failed', e);
      return false;
    }
  }

  /// Get available service types
  List<AIServiceType> getAvailableServiceTypes() {
    return AIServiceType.values;
  }

  /// Get service type display name
  String getServiceTypeName(AIServiceType type) {
    switch (type) {
      case AIServiceType.mock:
        return 'Mock AI (Testing)';
      case AIServiceType.ollama:
        return 'Ollama';
      case AIServiceType.googleAIEdge:
        return 'Google AI Edge';
    }
  }

  /// Get service type description
  String getServiceTypeDescription(AIServiceType type) {
    switch (type) {
      case AIServiceType.mock:
        return 'Mock AI engine for testing and development. Provides simulated responses.';
      case AIServiceType.ollama:
        return 'Connect to a local Ollama server for private AI processing.';
      case AIServiceType.googleAIEdge:
        return 'Use Google AI Edge models for completely offline AI processing on Android devices.';
    }
  }

  /// Check if current service is available
  Future<bool> isCurrentServiceAvailable() async {
    if (_currentService == null) {
      return false;
    }

    try {
      return await _currentService!.isAvailable();
    } catch (e) {
      AppLogger.warn('Error checking service availability', e);
      return false;
    }
  }

  /// Get current service status
  Future<Map<String, dynamic>> getCurrentServiceStatus() async {
    if (_currentService == null) {
      return {
        'available': false,
        'error': 'No service configured',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }

    try {
      final isAvailable = await _currentService!.isAvailable();
      final config = _currentService!.getConfig();

      return {
        'available': isAvailable,
        'serviceType': _currentConfig.serviceType.name,
        'config': config,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'available': false,
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Reset to default configuration
  Future<void> resetToDefault() async {
    AppLogger.info('Resetting AI configuration to default');
    final defaultConfig = AIConfigExtension.defaultFor(AIServiceType.mock);
    await updateConfig(defaultConfig);
  }

  /// Save current configuration
  Future<void> _saveConfig() async {
    try {
      final configJson = jsonEncode(_currentConfig.toJson());
      await _database.setValue(_configKey, configJson);
    } catch (e) {
      AppLogger.error('Failed to save AI configuration', e);
    }
  }

  /// Create service instance based on current configuration
  Future<void> _createServiceInstance() async {
    _currentService = await _createEngine(_currentConfig);
    if (_currentService == null) {
      AppLogger.warn('Failed to create engine, falling back to mock');
      _currentService = MockAIEngine();
    }
  }

  /// Create engine instance from configuration
  Future<ai_engine.AIEngine?> _createEngine(AIConfig config) async {
    try {
      switch (config.serviceType) {
        case AIServiceType.mock:
          return MockAIEngine();

        case AIServiceType.ollama:
          if (config.ollamaUrl == null || config.ollamaModel == null) {
            return null;
          }
          final ollamaService = OllamaService(
            baseUrl: config.ollamaUrl!,
            modelName: config.ollamaModel!,
            timeout: config.requestTimeout,
          );
          return AIEngineImpl(ollamaService);

        case AIServiceType.googleAIEdge:
          if (config.gemmaModelPath == null) {
            AppLogger.warn(
              'Google AI Edge model path not configured, using default',
            );
          }
          AppLogger.info('Creating Google AI Edge engine (MediaPipe LLM)');
          final mediapipeEngine = MediaPipeLLMEngine(
            modelPath: config.gemmaModelPath ?? '/path/to/gemma/model',
          );
          return AIEngineImpl(mediapipeEngine);
      }
    } catch (e) {
      AppLogger.error('Failed to create AI engine instance', e);
      return null;
    }
  }

  /// Dispose current service
  Future<void> _disposeCurrentService() async {
    if (_currentService == null) return;

    try {
      AppLogger.info(
        'Disposing current AI engine: ${_currentService.runtimeType}',
      );
      await _currentService!.dispose();
      _currentService = null;
      AppLogger.info('Current AI engine disposed successfully');
    } catch (e) {
      AppLogger.warn('Error disposing AI service', e);
      _currentService = null; // Still set to null even if dispose failed
    }
  }

  /// Dispose the configuration service
  Future<void> dispose() async {
    await _disposeCurrentService();
  }
}
