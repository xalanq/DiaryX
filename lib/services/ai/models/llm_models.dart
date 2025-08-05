import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_models.freezed.dart';
part 'llm_models.g.dart';

/// Configuration for LLM services
@freezed
class LLMEngineConfig with _$LLMEngineConfig {
  const factory LLMEngineConfig({
    required String baseUrl,
    required String modelName,
    String? apiKey,
    @Default({}) Map<String, dynamic> parameters,
    @Default(Duration(seconds: 30)) Duration timeout,
  }) = _LLMEngineConfig;

  factory LLMEngineConfig.fromJson(Map<String, dynamic> json) =>
      _$LLMEngineConfigFromJson(json);
}
