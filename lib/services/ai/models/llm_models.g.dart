// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LLMEngineConfigImpl _$$LLMEngineConfigImplFromJson(
  Map<String, dynamic> json,
) => _$LLMEngineConfigImpl(
  baseUrl: json['baseUrl'] as String,
  modelName: json['modelName'] as String,
  apiKey: json['apiKey'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
  timeout: json['timeout'] == null
      ? const Duration(seconds: 30)
      : Duration(microseconds: (json['timeout'] as num).toInt()),
);

Map<String, dynamic> _$$LLMEngineConfigImplToJson(
  _$LLMEngineConfigImpl instance,
) => <String, dynamic>{
  'baseUrl': instance.baseUrl,
  'modelName': instance.modelName,
  'apiKey': instance.apiKey,
  'parameters': instance.parameters,
  'timeout': instance.timeout.inMicroseconds,
};
