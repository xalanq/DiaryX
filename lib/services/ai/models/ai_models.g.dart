// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultImpl _$$SearchResultImplFromJson(Map<String, dynamic> json) =>
    _$SearchResultImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      relevanceScore: (json['relevanceScore'] as num).toDouble(),
    );

Map<String, dynamic> _$$SearchResultImplToJson(_$SearchResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'title': instance.title,
      'timestamp': instance.timestamp.toIso8601String(),
      'tags': instance.tags,
      'relevanceScore': instance.relevanceScore,
    };

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      analysis: json['analysis'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
  _$AnalysisResultImpl instance,
) => <String, dynamic>{
  'analysis': instance.analysis,
  'confidence': instance.confidence,
  'tags': instance.tags,
  'metadata': instance.metadata,
};

_$MoodAnalysisImpl _$$MoodAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$MoodAnalysisImpl(
      primaryMood: json['primaryMood'] as String,
      moodScore: (json['moodScore'] as num).toDouble(),
      confidenceScore: (json['confidenceScore'] as num).toDouble(),
      moodKeywords: (json['moodKeywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      secondaryMoods:
          (json['secondaryMoods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emotionalContext: json['emotionalContext'] as String?,
      moodDistribution: (json['moodDistribution'] as Map<String, dynamic>?)
          ?.map((k, e) => MapEntry(k, (e as num).toDouble())),
      analysisTimestamp: json['analysisTimestamp'] == null
          ? null
          : DateTime.parse(json['analysisTimestamp'] as String),
    );

Map<String, dynamic> _$$MoodAnalysisImplToJson(_$MoodAnalysisImpl instance) =>
    <String, dynamic>{
      'primaryMood': instance.primaryMood,
      'moodScore': instance.moodScore,
      'confidenceScore': instance.confidenceScore,
      'moodKeywords': instance.moodKeywords,
      'secondaryMoods': instance.secondaryMoods,
      'emotionalContext': instance.emotionalContext,
      'moodDistribution': instance.moodDistribution,
      'analysisTimestamp': instance.analysisTimestamp?.toIso8601String(),
    };

_$AIServiceConfigImpl _$$AIServiceConfigImplFromJson(
  Map<String, dynamic> json,
) => _$AIServiceConfigImpl(
  serviceName: json['serviceName'] as String,
  serviceType: json['serviceType'] as String,
  version: json['version'] as String,
  isEnabled: json['isEnabled'] as bool,
  settings: json['settings'] as Map<String, dynamic>? ?? const {},
  supportedFeatures:
      (json['supportedFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  description: json['description'] as String?,
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
);

Map<String, dynamic> _$$AIServiceConfigImplToJson(
  _$AIServiceConfigImpl instance,
) => <String, dynamic>{
  'serviceName': instance.serviceName,
  'serviceType': instance.serviceType,
  'version': instance.version,
  'isEnabled': instance.isEnabled,
  'settings': instance.settings,
  'supportedFeatures': instance.supportedFeatures,
  'description': instance.description,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
};

_$AIServiceStatusImpl _$$AIServiceStatusImplFromJson(
  Map<String, dynamic> json,
) => _$AIServiceStatusImpl(
  serviceName: json['serviceName'] as String,
  status: $enumDecode(_$ServiceStatusEnumMap, json['status']),
  capabilities: (json['capabilities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  version: json['version'] as String?,
  error: json['error'] as String?,
  llmBackend: json['llmBackend'] as Map<String, dynamic>?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$AIServiceStatusImplToJson(
  _$AIServiceStatusImpl instance,
) => <String, dynamic>{
  'serviceName': instance.serviceName,
  'status': _$ServiceStatusEnumMap[instance.status]!,
  'capabilities': instance.capabilities,
  'timestamp': instance.timestamp.toIso8601String(),
  'version': instance.version,
  'error': instance.error,
  'llmBackend': instance.llmBackend,
  'metadata': instance.metadata,
};

const _$ServiceStatusEnumMap = {
  ServiceStatus.operational: 'operational',
  ServiceStatus.degraded: 'degraded',
  ServiceStatus.offline: 'offline',
  ServiceStatus.error: 'error',
  ServiceStatus.maintenance: 'maintenance',
};
