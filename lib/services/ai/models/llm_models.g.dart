// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LLMServiceConfigImpl _$$LLMServiceConfigImplFromJson(
  Map<String, dynamic> json,
) => _$LLMServiceConfigImpl(
  baseUrl: json['baseUrl'] as String,
  modelName: json['modelName'] as String,
  apiKey: json['apiKey'] as String?,
  parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
  timeout: json['timeout'] == null
      ? const Duration(seconds: 30)
      : Duration(microseconds: (json['timeout'] as num).toInt()),
);

Map<String, dynamic> _$$LLMServiceConfigImplToJson(
  _$LLMServiceConfigImpl instance,
) => <String, dynamic>{
  'baseUrl': instance.baseUrl,
  'modelName': instance.modelName,
  'apiKey': instance.apiKey,
  'parameters': instance.parameters,
  'timeout': instance.timeout.inMicroseconds,
};
