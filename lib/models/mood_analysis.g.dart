// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mood_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoodAnalysisImpl _$$MoodAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$MoodAnalysisImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      momentId: (json['momentId'] as num).toInt(),
      moodScore: (json['moodScore'] as num?)?.toDouble(),
      primaryMood: json['primaryMood'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      moodKeywords: json['moodKeywords'] as String?,
      analysisTimestamp: DateTime.parse(json['analysisTimestamp'] as String),
    );

Map<String, dynamic> _$$MoodAnalysisImplToJson(_$MoodAnalysisImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'momentId': instance.momentId,
      'moodScore': instance.moodScore,
      'primaryMood': instance.primaryMood,
      'confidenceScore': instance.confidenceScore,
      'moodKeywords': instance.moodKeywords,
      'analysisTimestamp': instance.analysisTimestamp.toIso8601String(),
    };
