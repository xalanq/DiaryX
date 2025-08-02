// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmotionAnalysisImpl _$$EmotionAnalysisImplFromJson(
  Map<String, dynamic> json,
) => _$EmotionAnalysisImpl(
  id: (json['id'] as num?)?.toInt(),
  entryId: (json['entryId'] as num).toInt(),
  emotionScore: (json['emotionScore'] as num?)?.toDouble(),
  primaryEmotion: json['primaryEmotion'] as String?,
  confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
  emotionKeywords: json['emotionKeywords'] as String?,
  analysisTimestamp: DateTime.parse(json['analysisTimestamp'] as String),
);

Map<String, dynamic> _$$EmotionAnalysisImplToJson(
  _$EmotionAnalysisImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'entryId': instance.entryId,
  'emotionScore': instance.emotionScore,
  'primaryEmotion': instance.primaryEmotion,
  'confidenceScore': instance.confidenceScore,
  'emotionKeywords': instance.emotionKeywords,
  'analysisTimestamp': instance.analysisTimestamp.toIso8601String(),
};
