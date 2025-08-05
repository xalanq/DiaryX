import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_models.freezed.dart';
part 'config_models.g.dart';

/// AI service type enumeration
enum AIServiceType { mock, ollama, gemma }

/// Configuration for AI services
@freezed
class AIConfig with _$AIConfig {
  const factory AIConfig({
    @Default(AIServiceType.mock) AIServiceType serviceType,
    String? ollamaUrl,
    String? ollamaModel,
    String? gemmaModelPath,
    @Default(true) bool enableBackgroundProcessing,
    @Default(Duration(seconds: 30)) Duration requestTimeout,
    @Default({}) Map<String, dynamic> additionalParams,
  }) = _AIConfig;

  factory AIConfig.fromJson(Map<String, dynamic> json) =>
      _$AIConfigFromJson(json);
}

/// Extension methods for AIConfig
extension AIConfigExtension on AIConfig {
  /// Check if configuration is valid
  bool get isValid {
    switch (serviceType) {
      case AIServiceType.mock:
        return true;
      case AIServiceType.ollama:
        return ollamaUrl != null && ollamaModel != null;
      case AIServiceType.gemma:
        return gemmaModelPath != null;
    }
  }

  /// Get default configurations for each service type
  static AIConfig defaultFor(AIServiceType type) {
    switch (type) {
      case AIServiceType.mock:
        return const AIConfig(serviceType: AIServiceType.mock);
      case AIServiceType.ollama:
        return const AIConfig(
          serviceType: AIServiceType.ollama,
          ollamaUrl: 'http://localhost:11434',
          ollamaModel: 'llama2',
        );
      case AIServiceType.gemma:
        return const AIConfig(
          serviceType: AIServiceType.gemma,
          gemmaModelPath: '/path/to/gemma/model',
        );
    }
  }
}
