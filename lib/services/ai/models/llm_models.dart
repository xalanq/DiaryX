import 'package:freezed_annotation/freezed_annotation.dart';

part 'llm_models.freezed.dart';
part 'llm_models.g.dart';

/// Configuration for LLM services
@freezed
class LLMServiceConfig with _$LLMServiceConfig {
  const factory LLMServiceConfig({
    required String baseUrl,
    required String modelName,
    String? apiKey,
    @Default({}) Map<String, dynamic> parameters,
    @Default(Duration(seconds: 30)) Duration timeout,
  }) = _LLMServiceConfig;

  factory LLMServiceConfig.fromJson(Map<String, dynamic> json) =>
      _$LLMServiceConfigFromJson(json);
}
