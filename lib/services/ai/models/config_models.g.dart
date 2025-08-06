// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIConfigImpl _$$AIConfigImplFromJson(Map<String, dynamic> json) =>
    _$AIConfigImpl(
      serviceType:
          $enumDecodeNullable(_$AIServiceTypeEnumMap, json['serviceType']) ??
          AIServiceType.mock,
      ollamaUrl: json['ollamaUrl'] as String?,
      ollamaModel: json['ollamaModel'] as String?,
      gemmaModelPath: json['gemmaModelPath'] as String?,
      enableBackgroundProcessing:
          json['enableBackgroundProcessing'] as bool? ?? true,
      requestTimeout: json['requestTimeout'] == null
          ? const Duration(seconds: 30)
          : Duration(microseconds: (json['requestTimeout'] as num).toInt()),
      additionalParams:
          json['additionalParams'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$AIConfigImplToJson(_$AIConfigImpl instance) =>
    <String, dynamic>{
      'serviceType': _$AIServiceTypeEnumMap[instance.serviceType]!,
      'ollamaUrl': instance.ollamaUrl,
      'ollamaModel': instance.ollamaModel,
      'gemmaModelPath': instance.gemmaModelPath,
      'enableBackgroundProcessing': instance.enableBackgroundProcessing,
      'requestTimeout': instance.requestTimeout.inMicroseconds,
      'additionalParams': instance.additionalParams,
    };

const _$AIServiceTypeEnumMap = {
  AIServiceType.mock: 'mock',
  AIServiceType.ollama: 'ollama',
  AIServiceType.googleAIEdge: 'googleAIEdge',
};
