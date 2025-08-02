import 'package:freezed_annotation/freezed_annotation.dart';

part 'emotion_analysis.freezed.dart';
part 'emotion_analysis.g.dart';

/// Represents emotion analysis results for diary entries
@freezed
class EmotionAnalysis with _$EmotionAnalysis {
  const factory EmotionAnalysis({
    int? id,
    required int entryId,
    double? emotionScore, // -1.0 to 1.0 (negative to positive)
    String? primaryEmotion,
    double? confidenceScore, // 0.0 to 1.0
    String? emotionKeywords, // JSON array of emotion-related keywords
    required DateTime analysisTimestamp,
  }) = _EmotionAnalysis;

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$EmotionAnalysisFromJson(json);
}
