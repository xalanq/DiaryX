import 'package:freezed_annotation/freezed_annotation.dart';

part 'mood_analysis.freezed.dart';
part 'mood_analysis.g.dart';

/// Represents mood analysis results for diary moments
@freezed
class MoodAnalysis with _$MoodAnalysis {
  const factory MoodAnalysis({
    int? id,
    required int momentId,
    double? moodScore, // -1.0 to 1.0 (negative to positive)
    String? primaryMood,
    double? confidenceScore, // 0.0 to 1.0
    String? moodKeywords, // JSON array of mood-related keywords
    required DateTime analysisTimestamp,
  }) = _MoodAnalysis;

  factory MoodAnalysis.fromJson(Map<String, dynamic> json) =>
      _$MoodAnalysisFromJson(json);
}
